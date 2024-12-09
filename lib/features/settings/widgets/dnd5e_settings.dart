import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/settings/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class Dnd5eSettingsWidget extends StatelessWidget {
  const Dnd5eSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.read<SystemSettingsProvider>();
    final gameSettings = context.select<SystemSettingsProvider, Dnd5eSettings>(
        (state) => state.dnd5eSettings);
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: gameSettings.enabled,
          onChanged: (value) async {
            await systemSettings
                .set5eSettings(gameSettings.copyWith(enabled: value));
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'toggle_5e_bestiary',
              props: {'enabled': value.toString()},
            );
          },
          title: Text(
            localization.dnd5e_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(localization.dnd5e_settings_bestiary_toggle),
        ),
      ],
    );
  }
}
