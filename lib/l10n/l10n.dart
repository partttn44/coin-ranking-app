import 'package:coin_ranking_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
