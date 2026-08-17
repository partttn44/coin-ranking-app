import 'package:coin_ranking_app/viewmodels/coin_list/coin_model.dart';
import 'package:coin_ranking_data/domain/exception/coin_repository_exception.dart';
import 'package:coin_ranking_data/domain/repositories/coin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'coin_detail_state.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  CoinDetailCubit({required CoinRepository repository})
    : _repository = repository,
      super(const CoinDetailState());

  final CoinRepository _repository;

  Future<void> loadCoinDetail(String uuid) async {
    if (state.status == CoinDetailStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: CoinDetailStatus.loading,
        clearCoin: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final entity = await _repository.getCoinDetail(uuid: uuid);

      emit(
        state.copyWith(
          status: CoinDetailStatus.success,
          coin: CoinModel.fromEntity(entity),
          clearErrorMessage: true,
        ),
      );
    } on CoinRepositoryException catch (error) {
      emit(
        state.copyWith(
          status: CoinDetailStatus.failure,
          errorMessage: error.message,
          clearCoin: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CoinDetailStatus.failure,
          errorMessage: 'Something went wrong.',
          clearCoin: true,
        ),
      );
    }
  }
}
