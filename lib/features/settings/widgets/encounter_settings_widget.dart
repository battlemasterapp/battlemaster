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
                (state) => state.rollType),
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
              await context
                  .read<SystemSettingsProvider>()
                  .setInitiativeRollType(value!);
            },
          ),
        ),
      ],
    );
  }
}
