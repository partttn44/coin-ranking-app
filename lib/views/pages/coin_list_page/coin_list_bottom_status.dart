import 'package:coin_ranking_app/l10n/l10n.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinListBottomStatus extends StatelessWidget {
  const CoinListBottomStatus({required this.state, super.key});

  final CoinListState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return _buildLoading();
    }

    if (state.loadMoreError != null) {
      return _buildError(context);
    }

    return SizedBox(height: 16.h);
  }

  Widget _buildLoading() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }

  Widget _buildError(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.somethingWentWrong,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          TextButton(
            onPressed: () {
              context.read<CoinListBloc>().add(const CoinListRetryRequested());
            },
            child: Text(
              context.l10n.tryAgain,
              style: TextStyle(color: const Color(0xFFB499FC), fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
