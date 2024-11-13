import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/conditions/providers/conditions_provider.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wiredash/wiredash.dart';

import 'api/services/pf2e_bestiary_service.dart';
import 'features/analytics/analytics_observer.dart';
import 'features/analytics/plausible.dart';
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
        ProxyProvider<SystemSettingsProvider, Pf2eBestiaryService>(
          create: (context) {
            final settings =
                context.read<SystemSettingsProvider>().pf2eSettings;
            return Pf2eBestiaryService(
              bestiarySources: settings.enabled ? settings.bestiaries : {},
            )..fetchData();
          },
          update: (_, settings, service) {
            if (settings.pf2eSettings.bestiaries != service?.bestiarySources) {
              return Pf2eBestiaryService(
                bestiarySources: settings.pf2eSettings.enabled
                    ? settings.pf2eSettings.bestiaries
                    : {},
              )..fetchData(forceRefresh: true);
            }
            return service!;
          },
          lazy: false,
        ),
        ChangeNotifierProvider<Dnd5eEngineProvider>(
          create: (_) => Dnd5eEngineProvider()..fetchData(),
          lazy: false,
        ),
        Provider<AnalyticsService>(
          create: (_) => AnalyticsService(),
        ),
        ChangeNotifierProxyProvider<AppDatabase, ConditionsProvider>(
          create: (context) => ConditionsProvider(context.read<AppDatabase>()),
          update: (_, __, provider) => provider!,
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'BattleMaster',
          navigatorObservers: [
            AnalyticsNavigatorObserver(plausible),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: pf2eLightTheme,
          darkTheme: pf2eDarkTheme,
          themeMode: context.select<SystemSettingsProvider, ThemeMode>(
              (state) => state.themeMode),
          builder: (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 500, name: MOBILE),
              const Breakpoint(start: 501, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: Wiredash(
              projectId: const String.fromEnvironment('WIREDASH_PROJECT'),
              secret: const String.fromEnvironment('WIREDASH_SECRET'),
              feedbackOptions: WiredashFeedbackOptions(
                email: EmailPrompt.hidden,
                labels: [
                  Label(
                    id: 'label-0oezaz9t8j',
                    title: AppLocalizations.of(context)!.feedback_label_bug,
                  ),
                  Label(
                    id: 'label-ynr7f57jtv',
                    title: AppLocalizations.of(context)!.feedback_label_feature,
                  ),
                ],
              ),
              child: child!,
            ),
          ),
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
            "/combatant/add": (context) => AddCombatantPage(
                  params: ModalRoute.of(context)!.settings.arguments
                      as AddCombatantParams,
                ),
          },
          initialRoute: "/",
        );
      }),
    );
  }
}
