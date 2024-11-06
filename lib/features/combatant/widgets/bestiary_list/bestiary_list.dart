import 'package:flutter/material.dart';

import '../../models/combatant.dart';
import 'bestiary_tile_details.dart';

class BestiaryList extends StatelessWidget {
  const BestiaryList({
    super.key,
    this.combatants = const [],
    this.onCombatantSelected,
  });

  final List<Combatant> combatants;
  final VoidCallback? onCombatantSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return ListTile(
          onTap: onCombatantSelected,
          tileColor: _getTileColor(context, index),
          title: Text(combatant.name),
          subtitle: BestiaryTileDetails(combatant: combatant),
          trailing: combatant.level != null
              ? Text(
                  combatant.level.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                )
              : null,
        );
      },
    );
  }

  Color _getTileColor(BuildContext context, int index) {
    final color = Theme.of(context)!.colorScheme.primary;
    return index.isEven ? color.withOpacity(0.15) : color.withOpacity(0.05);
  }
}
