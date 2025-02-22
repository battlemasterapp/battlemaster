import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../models/encounter.dart';
import '../models/encounter_type.dart';
import 'encounter_tile.dart';

class EncountersGrid extends StatelessWidget {
  const EncountersGrid({
    super.key,
    this.encounters = const [],
    this.isLoading = false,
    this.type = EncounterType.encounter,
  });

  final List<Encounter> encounters;
  final bool isLoading;
  final EncounterType type;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      itemCount: encounters.length + 1,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ElevatedButton.icon(
            onPressed: () async {
              final encounter = Encounter(
                name: type == EncounterType.encounter
                    ? localization.new_encounter_name
                    : localization.new_group_name,
                type: type,
                combatants: [],
                engine: GameEngineType.pf2e,
              );
              final created = await context
                  .read<EncountersProvider>()
                  .createEncounter(encounter);
              // ignore: use_build_context_synchronously
              context.read<AnalyticsService>().logEvent(
                'create-encounter',
                props: {'type': type.toString()},
              );

              if (type == EncounterType.encounter) {
                // ignore: use_build_context_synchronously
                context.pushNamed(
                  "encounter",
                  pathParameters: {'encounterId': created.id.toString()},
                );
                return;
              }
              // ignore: use_build_context_synchronously
              context.pushNamed(
                "group",
                pathParameters: {'groupId': created.id.toString()},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(MingCute.plus_fill),
            label: Text(
              localization.add_new_encounter,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (index > encounters.length) {
          return null;
        }

        final encounter = encounters[index - 1];

        return EncounterGridTile(encounter: encounter);
      },
    );
  }
}
