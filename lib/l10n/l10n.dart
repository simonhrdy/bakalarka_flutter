import 'package:flutter/widgets.dart';
import 'package:sportmatter/l10n/arb/app_localizations.g.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
