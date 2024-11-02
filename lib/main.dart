import 'package:battlemaster/features/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/combats/combats_page.dart';
import 'features/groups/groups_page.dart';
import 'features/settings/settings_page.dart';
import 'flavors/pf2e/pf2e_theme.dart';

void main() {
  runApp(const BattlemasterApp());
}

class BattlemasterApp extends StatelessWidget {
  const BattlemasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BattleMaster',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: pf2eLightTheme,
      darkTheme: pf2eDarkTheme,
      themeMode: ThemeMode.system,
      routes: {
        "/": (context) => const MainPage(),
        "/groups": (context) => const GroupsPage(),
        "/settings": (context) => const SettingsPage(),
      },
      initialRoute: "/",
    );
  }
}
