import 'package:coin_ranking_app/core/utils/number_formatter.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_model.dart';
import 'package:coin_ranking_app/views/pages/coin_detail/coin_detail_bottom_sheet.dart';
import 'package:coin_ranking_app/views/widgets/coin_icon.dart';
import 'package:coin_ranking_app/views/widgets/coin_change_badge.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopThreeCoinsSection extends StatelessWidget {
  const TopThreeCoinsSection({required this.coins, super.key});

  final List<CoinModel> coins;

  @override
  Widget build(BuildContext context) {
    final topCoins = coins.take(3).toList(growable: false);

    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(topCoins.length, (index) {
          return Expanded(
            child: Padding(
              padding: REdgeInsets.only(
                left: index == 0 ? 0 : 3,
                right: index == topCoins.length - 1 ? 0 : 3,
              ),
              child: InkWell(
                onTap: () => CoinDetailBottomSheet.show(
                  context,
                  uuid: topCoins[index].uuid,
                ),
                child: TopCoinCard(coin: topCoins[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TopCoinCard extends StatelessWidget {
  const TopCoinCard({required this.coin, super.key});

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEDE7EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CoinIcon(iconUrl: coin.iconUrl, symbol: coin.symbol, size: 32),
          SizedBox(height: 6.h),
          Text(
            coin.symbol,
            maxLines: 1,

            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          FittedBox(
            child: Text(
              '\$${formatCurrency(coin.price)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          CoinChangeBadge(change: coin.change),
        ],
      ),
    );
  }
}
