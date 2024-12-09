import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'api/services/pf2e_bestiary_service.dart';
import 'features/combatant/add_combatant_page.dart';
import 'features/encounter_tracker/encounter_tracker_page.dart';
import 'features/encounters/providers/encounters_provider.dart';
import 'features/groups/group_detail_page.dart';
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
        ChangeNotifierProvider(
          create: (_) => SystemSettings(),
          lazy: false,
        ),
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProxyProvider<AppDatabase, EncountersProvider>(
          create: (context) => EncountersProvider(context.read<AppDatabase>()),
          update: (_, __, provider) => provider!,
        ),
        Provider<Pf2eBestiaryService>(
          create: (_) => Pf2eBestiaryService(),
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'BattleMaster',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: pf2eLightTheme,
          darkTheme: pf2eDarkTheme,
          themeMode: context
              .select<SystemSettings, ThemeMode>((state) => state.themeMode),
          routes: {
            "/": (context) => const MainPage(),
            "/encounter": (context) => EncounterTrackerPage(
                  params: ModalRoute.of(context)!.settings.arguments
                      as EncounterTrackerParams,
                ),
            "/group": (context) => GroupDetailPage(
                  params: ModalRoute.of(context)!.settings.arguments
                      as GroupDetailPageParams,
                ),
            "/combatant/add": (context) => const AddCombatantPage(),
          },
          initialRoute: "/",
        );
      }),
    );
  }
}
