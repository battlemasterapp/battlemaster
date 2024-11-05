import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
            subtitle: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final info = snapshot.data;
                return Text("v${info?.version}");
              },
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
