import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../models/encounter.dart';
import '../models/encounter_type.dart';

enum EncounterMenuOptions {
  deleteCombat,
  removeAllCombatants,
  convert,
}

class EncounterTileMenu extends StatelessWidget {
  const EncounterTileMenu({
    super.key,
    required this.encounter,
    this.iconColor,
  });

  final Encounter encounter;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: iconColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: EncounterMenuOptions.convert,
            child: Row(
              children: [
                Icon(
                  EvaIcons.flip_2,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                encounter.type == EncounterType.group
                    ? Text(AppLocalizations.of(context)!.convert_to_encounter)
                    : Text(AppLocalizations.of(context)!.convert_to_group),
              ],
            ),
          ),
          PopupMenuItem(
            value: EncounterMenuOptions.deleteCombat,
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                Text(AppLocalizations.of(context)!.delete_encounter),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == EncounterMenuOptions.deleteCombat) {
          await context.read<EncountersProvider>().removeEncounter(encounter);
          // ignore: use_build_context_synchronously
          await context.read<AnalyticsService>().logEvent('delete-encounter');
          return;
        }

        if (value == EncounterMenuOptions.convert) {
          await context
              .read<EncountersProvider>()
              .convertEncounterType(encounter);
          // ignore: use_build_context_synchronously
          await context.read<AnalyticsService>().logEvent('convert-encounter');
          return;
        }
      },
    );
  }
}

class EncounterViewMenu extends StatelessWidget {
  const EncounterViewMenu({
    super.key,
    required this.encounter,
  });

  final Encounter encounter;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: EncounterMenuOptions.convert,
            child: Row(
              children: [
                Icon(
                  EvaIcons.flip_2,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                encounter.type == EncounterType.group
                    ? const Text("Converter para combate")
                    : const Text("Converter para grupo"),
              ],
            ),
          ),
          PopupMenuItem(
            value: EncounterMenuOptions.removeAllCombatants,
            child: Row(
              children: [
                Icon(
                  Icons.group_remove,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                const Text("Remover todos"),
              ],
            ),
          ),
          PopupMenuItem(
            value: EncounterMenuOptions.deleteCombat,
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 4),
                const Text("Apagar combate"),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) async {
        if (value == EncounterMenuOptions.deleteCombat) {
          final removed = true;
          if (removed) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
          return;
        }

        if (value == EncounterMenuOptions.convert) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          return;
        }

        if (value == EncounterMenuOptions.removeAllCombatants) {
          // showRemoveAllDialog(context);
        }
      },
    );
  }
}
