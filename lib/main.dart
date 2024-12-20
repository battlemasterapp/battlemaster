import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/api/providers/pf2e_engine_provider.dart';
import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/conditions/custom_conditions_page.dart';
import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:wiredash/wiredash.dart';

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

  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
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

final _router = GoRouter(
  initialLocation: '/',
  observers: [
    AnalyticsNavigatorObserver(plausible),
  ],
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/encounter/:encounterId',
      name: 'encounter',
      builder: (context, state) => EncounterTrackerPage(
        encounterId: int.parse(state.pathParameters['encounterId']!),
      ),
    ),
    GoRoute(
      path: '/group/:groupId',
      name: 'group',
      builder: (context, state) => GroupDetailPage(
        groupId: int.parse(state.pathParameters['groupId']!),
      ),
    ),
    GoRoute(
      path: '/encounter/:encounterId/combatant/add',
      name: 'add-combatant',
      builder: (context, state) => AddCombatantPage(
        params: state.extra as AddCombatantParams,
      ),
    ),
    GoRoute(
      path: '/conditions',
      name: 'conditions',
      builder: (context, state) => const CustomConditionsPage(),
    ),
  ],
);

class BattlemasterApp extends StatelessWidget {
  const BattlemasterApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SystemSettingsProvider>(
          create: (_) => SystemSettingsProvider(),
        ),
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProxyProvider<AppDatabase, EncountersProvider>(
          create: (context) => EncountersProvider(context.read<AppDatabase>()),
          update: (_, __, provider) => provider!,
        ),
        ChangeNotifierProxyProvider<SystemSettingsProvider, Pf2eEngineProvider>(
          create: (context) {
            final settings =
                context.read<SystemSettingsProvider>().pf2eSettings;
            return Pf2eEngineProvider(
              sources: settings.enabled ? settings.bestiaries : {},
            )..fetchData();
          },
          update: (context, settings, service) {
            if (settings.pf2eSettings.enabled == false) {
              return service!;
            }
            final settingsSources = settings.pf2eSettings.bestiaries;
            final providerSources = service?.sources ?? {};
            final hasChanged = !setEquals(settingsSources, providerSources);
            if (hasChanged) {
              return Pf2eEngineProvider(sources: settingsSources)
                ..fetchData(forceRefresh: true);
            }
            return service!;
          },
          lazy: false,
        ),
        ChangeNotifierProxyProvider<SystemSettingsProvider,
            Dnd5eEngineProvider>(
          create: (context) {
            final settings =
                context.read<SystemSettingsProvider>().dnd5eSettings;
            return Dnd5eEngineProvider(
              sources: settings.enabled ? settings.sources : {},
            )..fetchData();
          },
          update: (context, settings, provider) {
            if (settings.dnd5eSettings.enabled == false) {
              return provider!;
            }
            final settingsSources = settings.dnd5eSettings.sources;
            final providerSources = provider?.sources ?? {};
            final hasChanged = !setEquals(settingsSources, providerSources);
            if (hasChanged) {
              return Dnd5eEngineProvider(
                sources: settings.dnd5eSettings.sources,
              )..fetchData(forceRefresh: true);
            }
            return provider!;
          },
          lazy: false,
        ),
        Provider<AnalyticsService>(
          create: (_) => AnalyticsService(),
          lazy: false,
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, PlayerViewNotifier>(
          create: (context) => PlayerViewNotifier(
            auth: context.read<AuthProvider>(),
          ),
          update: (_, auth, notifier) => notifier!..auth = auth,
        ),
      ],
      child: Builder(builder: (context) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            routerConfig: _router,
            title: 'Battlemaster',
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
                      title:
                          AppLocalizations.of(context)!.feedback_label_feature,
                    ),
                  ],
                ),
                child: child!,
              ),
            ),
          ),
        );
      }),
    );
  }
}
