import 'package:coin_ranking_app/core/utils/number_formatter.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_model.dart';
import 'package:coin_ranking_app/views/widgets/coin_icon.dart';
import 'package:coin_ranking_app/views/widgets/coin_change_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinItem extends StatelessWidget {
  final CoinModel coin;
  final VoidCallback onTap;

  const CoinItem({required this.coin, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CoinIcon(
            iconUrl: coin.iconUrl,
            symbol: coin.symbol,
            size: 40,
          ),
          title: Text(
            coin.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '\$${formatMarketCap(coin.marketCap)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            height: 30.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '\$${formatCurrency(coin.price)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CoinChangeBadge(change: coin.change),
              ],
            ),
          ),
        ),
        Divider(height: 2.h, indent: 72.w, color: Colors.grey.shade300),
      ],
    );
  }
}
