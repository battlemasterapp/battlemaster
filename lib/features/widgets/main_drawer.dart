import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            child: Text(
              "BattleMaster",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.combats_page_title),
            onTap: () {
              Navigator.of(context).pushNamed("/");
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.groups_page_title),
            onTap: () {
              Navigator.of(context).pushNamed("/groups");
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings_page_title),
            onTap: () {
              Navigator.of(context).pushNamed("/settings");
            },
          ),
        ],
      ),
    );
  }
}
