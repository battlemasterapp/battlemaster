import 'package:flutter/material.dart';

import '../models/encounter.dart';
import 'encounter_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EncountersGrid extends StatelessWidget {
  const EncountersGrid({
    super.key,
    this.encounters = const [],
    this.isLoading = false,
  });

  final List<Encounter> encounters;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(
              AppLocalizations.of(context)!.add_new_encounter,
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
