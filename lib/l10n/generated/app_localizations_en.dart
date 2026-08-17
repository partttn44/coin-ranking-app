// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get search => 'Search';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get inviteDescription => 'Get bonus coins for each friend!';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get unableToLoadCoins => 'Unable to load coins.';

  @override
  String get unableToLoadCoinDetail => 'Unable to load coin details.';

  @override
  String get emptyCoins => 'No coins found';

  @override
  String get tryAgain => 'Try again';

  @override
  String get price => 'Price';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get noDescription => 'No description';

  @override
  String get readMore => 'Read more';
}
