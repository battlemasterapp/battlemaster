import 'package:battlemaster/api/services/pf2e_bestiary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class Pf2eSettingsWidget extends StatelessWidget {
  const Pf2eSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.watch<SystemSettingsProvider>();
    return Column(
      children: [
        ListTile(
          title: Text(
            localization.pf2e_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SwitchListTile.adaptive(
          value: systemSettings.pf2eSettings.enabled,
          onChanged: (value) {
            systemSettings.setPF2eSettings(
                systemSettings.pf2eSettings.copyWith(enabled: value));
            context.read<Pf2eBestiaryService>().fetchData(forceRefresh: true);
          },
          title: Text(localization.pf2e_settings_bestiary_toggle),
        ),
      ],
    );
  }
}
