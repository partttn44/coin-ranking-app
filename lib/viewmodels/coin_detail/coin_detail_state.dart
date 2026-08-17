part of 'coin_detail_cubit.dart';

enum CoinDetailStatus { initial, loading, success, failure }

class CoinDetailState {
  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.coin,
    this.errorMessage,
  });

  final CoinDetailStatus status;
  final CoinModel? coin;
  final String? errorMessage;

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinModel? coin,
    String? errorMessage,
    bool clearCoin = false,
    bool clearErrorMessage = false,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      coin: clearCoin ? null : coin ?? this.coin,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
