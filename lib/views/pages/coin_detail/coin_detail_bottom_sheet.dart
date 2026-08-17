import 'package:coin_ranking_app/core/utils/number_formatter.dart';
import 'package:coin_ranking_app/injection/injection.dart';
import 'package:coin_ranking_app/l10n/l10n.dart';
import 'package:coin_ranking_app/viewmodels/coin_detail/coin_detail_cubit.dart';
import 'package:coin_ranking_app/viewmodels/coin_list/coin_model.dart';
import 'package:coin_ranking_app/views/widgets/coin_icon.dart';
import 'package:coin_ranking_app/views/widgets/coin_change_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinDetailBottomSheet extends StatelessWidget {
  const CoinDetailBottomSheet({required this.uuid, super.key});

  final String uuid;

  static Future<void> show(BuildContext context, {required String uuid}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return BlocProvider(
          create: (_) => getIt<CoinDetailCubit>()..loadCoinDetail(uuid),
          child: CoinDetailBottomSheet(uuid: uuid),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 230.h,
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BottomSheetHandle(),
          Flexible(
            child: BlocBuilder<CoinDetailCubit, CoinDetailState>(
              builder: (context, state) {
                if (state.status == CoinDetailStatus.initial ||
                    state.status == CoinDetailStatus.loading) {
                  return SizedBox(
                    height: 200.h,
                    child: const Center(child: CupertinoActivityIndicator()),
                  );
                }

                if (state.status == CoinDetailStatus.failure ||
                    state.coin == null) {
                  return _DetailErrorView(uuid: uuid);
                }

                return _CoinDetailContent(coin: state.coin!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF8D858E),
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}

class _CoinDetailContent extends StatelessWidget {
  const _CoinDetailContent({required this.coin});

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final description = _getDescription(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoinIcon(iconUrl: coin.iconUrl, symbol: coin.symbol, size: 54),
              SizedBox(width: 14.w),
              Expanded(child: _CoinInformation(coin: coin)),
              SizedBox(width: 6.w),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: CoinChangeBadge(
                  change: coin.change,
                  fontSize: 12,
                  showArrow: false,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF9D969F),
              fontSize: 13.sp,
              height: 1.25,
            ),
          ),
          if (_hasWebsite) ...[
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: _openWebsite,
              child: Text(
                context.l10n.readMore,
                style: TextStyle(
                  color: const Color(0xFF6A5CFF),
                  fontSize: 13.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF6A5CFF),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getDescription(BuildContext context) {
    final description = coin.description?.trim();

    if (description == null || description.isEmpty) {
      return context.l10n.noDescription;
    }

    return description;
  }

  bool get _hasWebsite {
    return coin.websiteUrl?.trim().isNotEmpty ?? false;
  }

  Future<void> _openWebsite() async {
    final website = coin.websiteUrl?.trim();

    if (website == null || website.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(website);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _CoinInformation extends StatelessWidget {
  const _CoinInformation({required this.coin});

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final coinColor = _parseColor(coin.color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: coin.name,
                style: TextStyle(
                  color: coinColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' (${coin.symbol})',
                style: TextStyle(
                  color: const Color(0xFF8B848D),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          softWrap: true,
        ),
        SizedBox(height: 4.h),
        _LabelValue(
          label: context.l10n.price,
          value: '\$${formatCurrency(coin.price)}',
        ),
        SizedBox(height: 2.h),
        _LabelValue(
          label: context.l10n.marketCap,
          value: '\$${formatMarketCap(coin.marketCap)}',
        ),
      ],
    );
  }

  Color _parseColor(String? hexadecimal) {
    final value = hexadecimal?.trim().replaceFirst('#', '');

    if (value == null || value.length != 6) {
      return const Color(0xFF6815C5);
    }

    final parsedColor = int.tryParse('FF$value', radix: 16);

    if (parsedColor == null) {
      return const Color(0xFF6815C5);
    }

    return Color(parsedColor);
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: const Color(0xFF69626B), fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _DetailErrorView extends StatelessWidget {
  const _DetailErrorView({required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.unableToLoadCoinDetail),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                context.read<CoinDetailCubit>().loadCoinDetail(uuid);
              },
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
