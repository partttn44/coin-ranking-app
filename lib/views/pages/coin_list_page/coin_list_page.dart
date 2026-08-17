import 'package:coin_ranking_app/injection/injection.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_list_bloc.dart';
import 'package:coin_ranking_app/views/pages/coin_list_page/coin_list_body.dart';
import 'package:coin_ranking_app/views/widgets/coin_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinListPage extends StatelessWidget {
  const CoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoinListBloc>()..add(const CoinListStarted()),
      child: const _CoinListView(),
    );
  }
}

class _CoinListView extends StatefulWidget {
  const _CoinListView();

  @override
  State<_CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<_CoinListView> {
  static const double _loadMoreThreshold = 200;

  late final ScrollController _scrollController;

  CoinListBloc get _bloc => context.read<CoinListBloc>();

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final triggerPosition = position.maxScrollExtent - _loadMoreThreshold;

    if (position.pixels >= triggerPosition) {
      _bloc.add(const CoinListLoadMoreRequested());
    }
  }

  Future<void> _handleRefresh() async {
    if (_bloc.state.isSearching || _bloc.state.isRefreshing) {
      return;
    }

    _bloc.add(const CoinListRefreshRequested());

    await _bloc.stream.firstWhere(
      (state) => !state.isRefreshing && state.status != CoinListStatus.loading,
    );
  }

  void _handleSearchChanged(String keyword) {
    _bloc.add(CoinSearchChanged(keyword));
  }

  void _handleSearchCleared() {
    _bloc.add(const CoinSearchCleared());
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FF),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: CoinSearchBar(
                  onChanged: _handleSearchChanged,
                  onClear: _handleSearchCleared,
                ),
              ),
              Expanded(
                child: BlocBuilder<CoinListBloc, CoinListState>(
                  builder: (context, state) {
                    return CoinListBody(
                      state: state,
                      scrollController: _scrollController,
                      onRefresh: _handleRefresh,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
