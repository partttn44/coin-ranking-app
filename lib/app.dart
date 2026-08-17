import 'package:coin_ranking_app/l10n/generated/app_localizations.dart';
import 'package:coin_ranking_app/views/pages/coin_list_page/coin_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinRankingApp extends StatelessWidget {
  const CoinRankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFFF7FF),
          ),
          home: child,
        );
      },
      child: const CoinListPage(),
    );
  }
}
