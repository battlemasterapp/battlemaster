import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.watch<SystemSettings>();
    return Column(
      children: [
        ListTile(
          title: Text(
            localization.app_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SwitchListTile(
          value: systemSettings.themeMode == ThemeMode.dark,
          onChanged: (value) async {
            await context.read<SystemSettings>().setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
          },
          title: Text(localization.dark_mode_toggle_label),
        ),
      ],
    );
  }
}
