import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinChangeBadge extends StatelessWidget {
  final double change;
  final int fontSize;
  final bool showArrow;
  const CoinChangeBadge({
    super.key,
    required this.change,
    this.fontSize = 9,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: fontSize.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 2.w),
          if (showArrow)
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: fontSize.sp,
            ),
        ],
      ),
    );
  }
}
