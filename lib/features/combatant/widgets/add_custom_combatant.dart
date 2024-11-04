import 'package:flutter/material.dart';

import '../models/combatant.dart';

class AddCustomCombatant extends StatelessWidget {
  const AddCustomCombatant({
    super.key,
    this.onCombatantAdded,
  });

  final ValueChanged<Combatant>? onCombatantAdded;

  @override
  Widget build(BuildContext context) {
    return const Text("custom combatant");
  }
}
