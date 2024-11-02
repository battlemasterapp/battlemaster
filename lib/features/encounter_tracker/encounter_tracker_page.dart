import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/material.dart';

class EncounterTrackerParams {
  final Encounter encounter;

  const EncounterTrackerParams({
    required this.encounter,
  });
}

class EncounterTrackerPage extends StatelessWidget {
  const EncounterTrackerPage({
    super.key,
    required this.params,
  });

  final EncounterTrackerParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params.encounter.name),
      ),
      body: Center(
        child: Text('Encounter id: ${params.encounter.id}'),
      ),
    );
  }
}
