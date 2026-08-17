import 'package:coin_ranking_app/l10n/l10n.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_list_bloc.dart';
import 'package:coin_ranking_app/views/pages/coin_list_page/coin_list_content.dart';
import 'package:coin_ranking_app/views/widgets/coin_error_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinListBody extends StatelessWidget {
  const CoinListBody({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    super.key,
  });

  final CoinListState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (_isInitialFailure) {
      return CoinErrorView(
        message: state.errorMessage ?? context.l10n.somethingWentWrong,
        onRetry: () {
          context.read<CoinListBloc>().add(const CoinListRetryRequested());
        },
      );
    }

    if (_isEmptySearch) {
      return const EmptyCoinView();
    }

    return CoinListContent(
      state: state,
      scrollController: scrollController,
      onRefresh: onRefresh,
    );
  }

  bool get _isInitialLoading {
    return state.status == CoinListStatus.initial ||
        state.status == CoinListStatus.loading;
  }

  bool get _isInitialFailure {
    return state.status == CoinListStatus.failure && state.coins.isEmpty;
  }

  bool get _isEmptySearch {
    return state.isSearching && state.coins.isEmpty;
  }
}
