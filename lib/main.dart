import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/analytics/plausible.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plausible_analytics/navigator_observer.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'api/services/dnd5e_bestiary_service.dart';
import 'api/services/pf2e_bestiary_service.dart';
import 'features/combatant/add_combatant_page.dart';
import 'features/encounter_tracker/encounter_tracker_page.dart';
import 'features/encounters/providers/encounters_provider.dart';
import 'features/groups/group_detail_page.dart';
import 'features/main_page/main_page.dart';
import 'flavors/pf2e/pf2e_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const sentryDsn = String.fromEnvironment('SENTRY_DSN');
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      options.tracesSampleRate = kReleaseMode ? .5 : 1.0;
      options.profilesSampleRate = kReleaseMode ? .5 : 1.0;
    },
    appRunner: () => runApp(const BattlemasterApp()),
  );
}

class BattlemasterApp extends StatelessWidget {
  const BattlemasterApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SystemSettingsProvider(),
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
        Provider<Dnd5eBestiaryService>(
          create: (_) => Dnd5eBestiaryService(),
          lazy: false,
        ),
        Provider<AnalyticsService>(
          create: (_) => AnalyticsService(),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'BattleMaster',
          navigatorObservers: [
            PlausibleNavigatorObserver(plausible),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: pf2eLightTheme,
          darkTheme: pf2eDarkTheme,
          themeMode: context.select<SystemSettingsProvider, ThemeMode>(
              (state) => state.themeMode),
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
