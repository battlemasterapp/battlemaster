import 'package:flutter/material.dart';

import 'widgets/app_settings.dart';
import 'widgets/encounter_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "Battlemaster",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const Divider(),
          const AppSettings(),
          const Divider(),
          const EncounterSettings(),
        ],
      ),
    );
  }
}
