import 'package:coin_ranking_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinErrorView extends StatelessWidget {
  const CoinErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: REdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                context.l10n.tryAgain,
                style: TextStyle(
                  color: const Color.fromARGB(255, 180, 153, 252),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCoinView extends StatelessWidget {
  const EmptyCoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.emptyCoins,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, color: Color(0xFF8C8C8C)),
      ),
    );
  }
}
