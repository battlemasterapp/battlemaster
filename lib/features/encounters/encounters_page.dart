import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/encounters/widgets/encounters_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/encounters_provider.dart';

class CombatsPage extends StatelessWidget {
  const CombatsPage({
    super.key,
    this.type = EncounterType.encounter,
  });

  final EncounterType type;

  @override
  Widget build(BuildContext context) {
    final encountersState = context.read<EncountersProvider>();
    return StreamBuilder<List<Encounter>>(
      stream: encountersState.watchEncounters(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final encounters = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Expanded(
                child: EncountersGrid(
                  encounters: encounters,
                  type: EncounterType.encounter,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
