import 'package:flutter/material.dart';

import '../../models/combatant.dart';
import 'bestiary_list_tile.dart';

class BestiaryList extends StatelessWidget {
  const BestiaryList({
    super.key,
    this.combatants = const [],
    this.onCombatantSelected,
  });

  final List<Combatant> combatants;
  final ValueChanged<Combatant>? onCombatantSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return BestiaryListTile(
          onTap: () => onCombatantSelected?.call(combatant),
          tileColor: _getTileColor(context, index),
          combatant: combatant,
        );
      },
    );
  }

  Color _getTileColor(BuildContext context, int index) {
    final color = Theme.of(context)!.colorScheme.primary;
    return index.isEven ? color.withOpacity(0.15) : color.withOpacity(0.05);
  }
}
