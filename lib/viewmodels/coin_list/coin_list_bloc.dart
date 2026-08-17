import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:coin_ranking_data/domain/exception/coin_repository_exception.dart';
import 'package:coin_ranking_data/domain/repositories/coin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import 'coin_model.dart';

part 'coin_list_event.dart';
part 'coin_list_state.dart';

EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounce(duration), mapper);
  };
}

class CoinListBloc extends Bloc<CoinListEvent, CoinListState> {
  CoinListBloc({required CoinRepository repository})
    : _repository = repository,
      super(const CoinListState()) {
    on<CoinListStarted>(_onStarted);

    on<CoinListLoadMoreRequested>(_onLoadMore, transformer: droppable());

    on<CoinListRefreshRequested>(_onRefresh);
    on<CoinListRetryRequested>(_onRetry);

    on<CoinSearchChanged>(
      _onSearchChanged,
      transformer: _debounceRestartable(const Duration(seconds: 1)),
    );

    on<CoinSearchCleared>(_onSearchCleared);
  }

  static const int _pageSize = 10;

  final CoinRepository _repository;

  String _latestSearchText = '';

  @override
  void onEvent(CoinListEvent event) {
    if (event is CoinSearchChanged) {
      _latestSearchText = event.keyword.trim();
    } else if (event is CoinSearchCleared) {
      _latestSearchText = '';
    }

    super.onEvent(event);
  }

  Future<void> _onStarted(CoinListStarted event, Emitter<CoinListState> emit) {
    return _loadFirstPage(emit, keyword: '');
  }

  Future<void> _onSearchChanged(
    CoinSearchChanged event,
    Emitter<CoinListState> emit,
  ) async {
    final keyword = event.keyword.trim();

    if (keyword != _latestSearchText) {
      return;
    }

    await _loadFirstPage(emit, keyword: keyword);
  }

  Future<void> _onSearchCleared(
    CoinSearchCleared event,
    Emitter<CoinListState> emit,
  ) {
    return _loadFirstPage(emit, keyword: '');
  }

  Future<void> _onRefresh(
    CoinListRefreshRequested event,
    Emitter<CoinListState> emit,
  ) async {
    if (state.isSearching) {
      return;
    }

    emit(
      state.copyWith(
        isRefreshing: true,
        clearErrorMessage: true,
        clearLoadMoreError: true,
      ),
    );

    await _loadFirstPage(emit, keyword: '', showFullLoading: false);
  }

  Future<void> _onRetry(
    CoinListRetryRequested event,
    Emitter<CoinListState> emit,
  ) async {
    if (state.loadMoreError != null && state.coins.isNotEmpty) {
      await _loadNextPage(emit);
      return;
    }

    await _loadFirstPage(emit, keyword: state.keyword);
  }

  Future<void> _onLoadMore(
    CoinListLoadMoreRequested event,
    Emitter<CoinListState> emit,
  ) async {
    if (state.status != CoinListStatus.success ||
        state.isLoadingMore ||
        state.hasReachedMax) {
      return;
    }

    await _loadNextPage(emit);
  }

  Future<void> _loadFirstPage(
    Emitter<CoinListState> emit, {
    required String keyword,
    bool showFullLoading = true,
  }) async {
    emit(
      state.copyWith(
        status: showFullLoading ? CoinListStatus.loading : state.status,
        keyword: keyword,
        coins: showFullLoading ? const [] : state.coins,
        topCoins: showFullLoading ? const [] : state.topCoins,
        nextOffset: 0,
        total: 0,
        hasReachedMax: false,
        isLoadingMore: false,
        clearErrorMessage: true,
        clearLoadMoreError: true,
      ),
    );

    try {
      final result = await _repository.getCoins(
        offset: 0,
        limit: _pageSize,
        search: keyword,
      );

      final fetchedCoins = result.coins
          .take(_pageSize)
          .map(CoinModel.fromEntity)
          .toList(growable: false);

      final isSearching = keyword.isNotEmpty;

      final topCoins = isSearching
          ? const <CoinModel>[]
          : fetchedCoins.take(3).toList(growable: false);

      final listCoins = isSearching
          ? fetchedCoins
          : fetchedCoins.skip(3).toList(growable: false);

      final nextOffset = fetchedCoins.length;

      emit(
        state.copyWith(
          status: CoinListStatus.success,
          coins: listCoins,
          topCoins: topCoins,
          keyword: keyword,
          nextOffset: nextOffset,
          total: result.total,
          hasReachedMax: fetchedCoins.isEmpty || nextOffset >= result.total,
          isRefreshing: false,
          clearErrorMessage: true,
          clearLoadMoreError: true,
        ),
      );
    } on CoinRepositoryException catch (error) {
      emit(
        state.copyWith(
          status: CoinListStatus.failure,
          coins: const [],
          topCoins: const [],
          keyword: keyword,
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CoinListStatus.failure,
          coins: const [],
          topCoins: const [],
          keyword: keyword,
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> _loadNextPage(Emitter<CoinListState> emit) async {
    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final result = await _repository.getCoins(
        offset: state.nextOffset,
        limit: _pageSize,
        search: state.keyword,
      );

      final fetchedCoins = result.coins
          .take(_pageSize)
          .map(CoinModel.fromEntity)
          .toList(growable: false);

      final nextOffset = state.nextOffset + fetchedCoins.length;

      emit(
        state.copyWith(
          coins: [...state.coins, ...fetchedCoins],
          nextOffset: nextOffset,
          total: result.total,
          hasReachedMax: fetchedCoins.isEmpty || nextOffset >= result.total,
          isLoadingMore: false,
          clearLoadMoreError: true,
        ),
      );
    } on CoinRepositoryException catch (error) {
      emit(state.copyWith(isLoadingMore: false, loadMoreError: error.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          loadMoreError: 'Something went wrong.',
        ),
      );
    }
  }
}
