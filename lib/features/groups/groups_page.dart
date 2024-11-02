import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../encounters/models/encounter.dart';
import '../encounters/widgets/encounters_grid.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: hardcoded for now. get all encounters from the database
    final database = context.watch<AppDatabase>();
    return StreamBuilder<List<Encounter>>(
      stream: database.watchAllGroups(),
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
                type: EncounterType.group,
              ),
            ),
          ],
        );
      },
    );
  }
}
