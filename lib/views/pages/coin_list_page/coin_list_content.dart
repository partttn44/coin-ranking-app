import 'package:coin_ranking_app/viewmodels/coin_list/coin_list_bloc.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_model.dart';
import 'package:coin_ranking_app/views/pages/coin_detail/coin_detail_bottom_sheet.dart';
import 'package:coin_ranking_app/views/pages/coin_list_page/coin_list_bottom_status.dart';
import 'package:coin_ranking_app/views/pages/coin_list_page/coin_refresh_indicator.dart';
import 'package:coin_ranking_app/views/widgets/coin_item.dart';
import 'package:coin_ranking_app/views/widgets/invite_friends_item.dart';
import 'package:coin_ranking_app/views/widgets/top_coin_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinListContent extends StatelessWidget {
  const CoinListContent({
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
    final entries = _buildEntries(state.coins);
    final coinList = _buildCoinList(entries);

    return Column(
      children: [
        if (_shouldShowTopCoins) ...[
          TopThreeCoinsSection(coins: state.topCoins),
          SizedBox(height: 8.h),
        ],
        Expanded(
          child: state.isSearching
              ? coinList
              : CoinRefreshIndicator(onRefresh: onRefresh, child: coinList),
        ),
      ],
    );
  }

  bool get _shouldShowTopCoins {
    return !state.isSearching && state.topCoins.isNotEmpty;
  }

  Widget _buildCoinList(List<_CoinListEntry> entries) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == entries.length) {
          return CoinListBottomStatus(state: state);
        }

        final entry = entries[index];

        if (entry.isInvite) {
          return const InviteFriendsItem();
        }

        return CoinItem(
          coin: entry.coin!,
          onTap: () =>
              CoinDetailBottomSheet.show(context, uuid: entry.coin!.uuid),
        );
      },
    );
  }

  List<_CoinListEntry> _buildEntries(List<CoinModel> coins) {
    final entries = <_CoinListEntry>[];

    var coinIndex = 0;
    var displayPosition = 1;

    while (coinIndex < coins.length) {
      if (_isInvitePosition(displayPosition)) {
        entries.add(const _CoinListEntry.invite());
      } else {
        entries.add(_CoinListEntry.coin(coins[coinIndex]));

        coinIndex++;
      }

      displayPosition++;
    }

    return entries;
  }

  bool _isInvitePosition(int position) {
    if (position == 5) {
      return true;
    }

    if (position < 10) {
      return false;
    }

    var invitePosition = 10;

    while (invitePosition < position) {
      invitePosition *= 2;
    }

    return position == invitePosition;
  }
}

class _CoinListEntry {
  const _CoinListEntry.coin(this.coin) : isInvite = false;

  const _CoinListEntry.invite() : coin = null, isInvite = true;

  final CoinModel? coin;
  final bool isInvite;
}
