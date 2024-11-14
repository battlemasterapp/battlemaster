import 'package:battlemaster/features/settings/models/skip_dead_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../models/initiative_roll_type.dart';
import '../providers/system_settings_provider.dart';

class EncounterSettingsWidget extends StatelessWidget {
  const EncounterSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        ListTile(
          title: Text(localization.encounter_settings_title,
              style: Theme.of(context).textTheme.headlineSmall),
          subtitle: Text(localization.encounter_settings_description),
        ),
        ListTile(
          leading: Icon(FontAwesome.dice_d20_solid),
          title: Text(localization.initiative_roll_title),
          subtitle: Text(localization.initiative_roll_description),
          trailing: DropdownButton<InitiativeRollType>(
            value: context.select<SystemSettingsProvider, InitiativeRollType>(
              (state) => state.rollType,
            ),
            items: InitiativeRollType.values.map((type) {
              final textMap = {
                InitiativeRollType.manual:
                    localization.initiative_roll_type_manual,
                InitiativeRollType.monstersOnly:
                    localization.initiative_roll_type_monstersOnly,
                InitiativeRollType.all: localization.initiative_roll_type_all,
              };
              return DropdownMenuItem(
                value: type,
                child: Text(textMap[type]!),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) {
                return;
              }

              await context
                  .read<SystemSettingsProvider>()
                  .setInitiativeRollType(value);
            },
          ),
        ),
        ListTile(
          leading: Icon(MingCute.skull_fill),
          title: Text(localization.skip_dead_title),
          subtitle: Text(localization.skip_dead_description),
          trailing: DropdownButton<SkipDeadBehavior>(
            value: context.select<SystemSettingsProvider, SkipDeadBehavior>(
              (state) => state.skipDeadBehavior,
            ),
            items: SkipDeadBehavior.values.map((type) {
              final textMap = {
                SkipDeadBehavior.all: localization.skip_dead_behavior_all,
                SkipDeadBehavior.allButPlayers:
                    localization.skip_dead_behavior_allButPlayers,
                SkipDeadBehavior.none: localization.skip_dead_behavior_none,
              };
              return DropdownMenuItem(
                value: type,
                child: Text(textMap[type]!),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) {
                return;
              }
              await context
                  .read<SystemSettingsProvider>()
                  .setSkipDeadBehavior(value);
            },
          ),
        ),
        ListTile(
          leading: Icon(MingCute.bling_fill),
          title: Text(localization.custom_conditions_settings_title),
          subtitle: Text(localization.custom_conditions_settings_subtitle),
          trailing: Icon(MingCute.right_fill),
          onTap: () {
            Navigator.of(context).pushNamed('/conditions');
          },
        ),
      ],
    );
  }
}
