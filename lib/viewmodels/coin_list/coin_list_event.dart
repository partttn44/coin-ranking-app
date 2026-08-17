part of 'coin_list_bloc.dart';

sealed class CoinListEvent extends Equatable {
  const CoinListEvent();

  @override
  List<Object?> get props => [];
}

final class CoinListStarted extends CoinListEvent {
  const CoinListStarted();
}

final class CoinListLoadMoreRequested extends CoinListEvent {
  const CoinListLoadMoreRequested();
}

final class CoinListRefreshRequested extends CoinListEvent {
  const CoinListRefreshRequested();
}

final class CoinListRetryRequested extends CoinListEvent {
  const CoinListRetryRequested();
}

final class CoinSearchChanged extends CoinListEvent {
  const CoinSearchChanged(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

final class CoinSearchCleared extends CoinListEvent {
  const CoinSearchCleared();
}
