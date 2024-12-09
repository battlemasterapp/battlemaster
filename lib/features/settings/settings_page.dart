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
                applicationLegalese:
                    "This app uses trademarks and/or copyrights owned by Paizo Inc., used under Paizo's Community Use Policy (paizo.com/communityuse). We are expressly prohibited from charging you to use or access this content. This app is not published, endorsed, or specifically approved by Paizo. For more information about Paizo Inc. and Paizo products, visit paizo.com.",
                icon: const Icon(Icons.info),
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
          const EncounterSettings(),
        ],
      ),
    );
  }
}
