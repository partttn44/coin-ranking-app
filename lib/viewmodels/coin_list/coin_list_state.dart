part of 'coin_list_bloc.dart';

enum CoinListStatus { initial, loading, success, failure }

class CoinListState extends Equatable {
  const CoinListState({
    this.status = CoinListStatus.initial,
    this.coins = const [],
    this.topCoins = const [],
    this.keyword = '',
    this.nextOffset = 0,
    this.total = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.loadMoreError,
  });

  final CoinListStatus status;
  final List<CoinModel> coins;
  final List<CoinModel> topCoins;
  final String keyword;
  final int nextOffset;
  final int total;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final String? loadMoreError;

  bool get isSearching => keyword.isNotEmpty;

  CoinListState copyWith({
    CoinListStatus? status,
    List<CoinModel>? coins,
    List<CoinModel>? topCoins,
    String? keyword,
    int? nextOffset,
    int? total,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return CoinListState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      topCoins: topCoins ?? this.topCoins,
      keyword: keyword ?? this.keyword,
      nextOffset: nextOffset ?? this.nextOffset,
      total: total ?? this.total,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      loadMoreError:
          clearLoadMoreError ? null : loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        coins,
        topCoins,
        keyword,
        nextOffset,
        total,
        hasReachedMax,
        isLoadingMore,
        isRefreshing,
        errorMessage,
        loadMoreError,
      ];
}
