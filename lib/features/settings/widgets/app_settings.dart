import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/analytics/plausible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

import '../providers/system_settings_provider.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.watch<SystemSettingsProvider>();
    return Column(
      children: [
        ListTile(
          title: Text(
            localization.app_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListTile(
          leading: Icon(MingCute.message_4_fill),
          title: Text(localization.settings_feedback_title),
          subtitle: Text(localization.settings_feedback_description),
          onTap: () {
            Wiredash.of(context).show(inheritMaterialTheme: true);
          },
          trailing: Icon(MingCute.right_fill),
        ),
        SwitchListTile.adaptive(
          secondary: const Icon(MingCute.moon_fill),
          value: systemSettings.themeMode == ThemeMode.dark,
          onChanged: (value) async {
            await context.read<SystemSettingsProvider>().setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
          },
          title: Text(localization.dark_mode_toggle_label),
        ),
        SwitchListTile.adaptive(
          secondary: const Icon(MingCute.chart_vertical_fill),
          value: systemSettings.analyticsEnabled,
          onChanged: (value) async {
            await context.read<SystemSettingsProvider>().setSettings(
                  systemSettings.settings.copyWith(analyticsEnabled: value),
                );
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'toggle_analytics',
              props: {'enabled': value.toString()},
            );
            plausible.isActive = value;
          },
          title: Text(localization.analytics_toggle_label),
        ),
      ],
    );
  }
}
