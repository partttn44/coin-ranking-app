import 'package:coin_ranking_app/app.dart';
import 'package:coin_ranking_app/injection/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(CoinRankingApp());
}
