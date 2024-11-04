import 'package:flutter/material.dart';

import '../encounter_tracker/widgets/combatant_tracker_list.dart';
import '../encounters/models/encounter.dart';

class GroupDetailPageParams {
  final Encounter encounter;

  const GroupDetailPageParams({
    required this.encounter,
  });
}

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({
    super.key,
    required this.params,
  });

  final GroupDetailPageParams params;

  @override
  Widget build(BuildContext context) {
    final encounter = params.encounter;
    return Scaffold(
      appBar: AppBar(
        title: Text(encounter.name),
      ),
      body: SafeArea(
        child: CombatantTrackerList(
          combatants: encounter.combatants,
        ),
      ),
    );
  }
}
