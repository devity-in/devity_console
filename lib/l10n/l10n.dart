import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A custom [AppLocalizations] delegate that
///  uses a [GlobalMaterialLocalizations].
extension AppLocalizationsX on BuildContext {
  /// The translations for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
