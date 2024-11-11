import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildWidgetTree(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: [
      const Locale('en'),
    ],
    home: Scaffold(
      body: Center(
        child: child,
      ),
    ),
  );
}
