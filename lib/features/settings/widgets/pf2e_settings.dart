import 'package:battlemaster/features/settings/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class Pf2eSettingsWidget extends StatelessWidget {
  const Pf2eSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.read<SystemSettingsProvider>();
    final gameSettings = context.select<SystemSettingsProvider, PF2eSettings>(
        (state) => state.pf2eSettings);
    return Column(
      children: [
        ListTile(
          title: Text(
            localization.pf2e_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SwitchListTile.adaptive(
          value: gameSettings.enabled,
          onChanged: (value) async {
            await systemSettings.setPF2eSettings(
              gameSettings.copyWith(enabled: value),
            );
          },
          title: Text(localization.pf2e_settings_bestiary_toggle),
        ),
      ],
    );
  }
}
