import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'legal/dnd5e_legal.dart';
import 'legal/pf2e_legal.dart';
import 'widgets/app_settings.dart';
import 'widgets/dnd5e_settings.dart';
import 'widgets/encounter_settings_widget.dart';
import 'widgets/pf2e_settings.dart';

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
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return AboutListTile(
                applicationName: "Battlemaster",
                applicationVersion: "v${snapshot.data?.version}",
                applicationLegalese: "$pf2eLegal\n\n$dnd5eLegal\n\n$ogl",
                icon: const Icon(MingCute.information_fill),
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 48,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          const AppSettings(),
          const Divider(),
          const EncounterSettingsWidget(),
          const Divider(),
          const Dnd5eSettingsWidget(),
          const Divider(),
          const Pf2eSettingsWidget(),
        ],
      ),
    );
  }
}
