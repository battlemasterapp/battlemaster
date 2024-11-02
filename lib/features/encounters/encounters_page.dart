import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/encounters/widgets/encounters_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatsPage extends StatelessWidget {
  const CombatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: hardcoded for now. get all encounters from the database
    final database = context.watch<AppDatabase>();
    return StreamBuilder<List<Encounter>>(
      stream: database.watchAllEncounters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final encounters = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: EncountersGrid(
                encounters: encounters,
                type: EncounterType.encounter,
              ),
            ),
          ],
        );
      },
    );
  }
}
