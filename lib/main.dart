import 'package:battlemaster/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'features/encounter_tracker/encounter_tracker_page.dart';
import 'features/main_page/main_page.dart';
import 'flavors/pf2e/pf2e_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const BattlemasterApp());
}

class BattlemasterApp extends StatelessWidget {
  const BattlemasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
      ],
      child: MaterialApp(
        title: 'BattleMaster',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: pf2eLightTheme,
        darkTheme: pf2eDarkTheme,
        themeMode: ThemeMode.system,
        routes: {
          "/": (context) => const MainPage(),
          "/encounter": (context) => EncounterTrackerPage(
                params: ModalRoute.of(context)!.settings.arguments
                    as EncounterTrackerParams,
              ),
        },
        initialRoute: "/",
      ),
    );
  }
}
