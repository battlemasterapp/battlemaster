import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../encounters/models/encounter.dart';
import '../encounters/providers/encounters_provider.dart';
import '../encounters/widgets/encounters_grid.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final encountersState = context.read<EncountersProvider>();
    return StreamBuilder<List<Encounter>>(
      stream: encountersState.watchGroups(),
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
