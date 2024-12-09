import 'package:battlemaster/features/settings/widgets/custom_bestiaries_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'widgets/app_settings.dart';
import 'widgets/dnd5e_settings.dart';
import 'widgets/encounter_settings_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    final tabs = <Tab, Widget>{
      Tab(child: Text(localization.settings_tab_app)): const AppSettings(),
      Tab(child: Text(localization.settings_tab_encounters)):
          const EncounterSettingsWidget(),
      Tab(child: Text(localization.settings_tab_custom_bestiaries)):
          const CustomBestiariesSettings(),
      Tab(child: Text(localization.settings_tab_5e)):
          const Dnd5eSettingsWidget(),
    };

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              title: Text(
                "Battlemaster",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            TabBar(
              isScrollable: isMobile,
              tabs: tabs.keys.toList(),
            ),
            Expanded(
              child: TabBarView(
                children: tabs.values
                    .map((w) => SingleChildScrollView(child: w))
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 24, top: 32),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      localization.made_with_love,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      localization.copyright,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
