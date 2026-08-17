import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinRefreshIndicator extends StatelessWidget {
  const CoinRefreshIndicator({
    required this.onRefresh,
    required this.child,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      offsetToArmed: 80.h,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            return AnimatedBuilder(
              animation: controller,
              child: child,
              builder: (context, child) {
                final progress = controller.value.clamp(0.0, 1.0).toDouble();

                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Transform.translate(
                      offset: Offset(0, progress * 55.h),
                      child: child!,
                    ),
                    Positioned(
                      top: 14.h,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: progress,
                          child: const CupertinoActivityIndicator(
                            radius: 11,
                            color: Color(0xFF6815C5),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
      child: child,
    );
  }
}
