import 'package:battlemaster/features/encounter_tracker/widgets/initiative_dialog.dart';
import 'package:flutter/material.dart';

import '../../combatant/models/combatant.dart';

class TrackerTile extends StatelessWidget {
  const TrackerTile({
    super.key,
    required this.combatant,
    required this.index,
    this.selected = false,
    this.onInitiativeChanged,
  });

  final bool selected;
  final Combatant combatant;
  final int index;
  final ValueChanged<double>? onInitiativeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getTileColor(context, index),
        border: Border.symmetric(
          vertical: BorderSide(
            color: _getBorderColor(context),
            width: 4,
          ),
          horizontal: BorderSide(
            color: _getBorderColor(context),
            width: 1.5,
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () async {
              final value = await showDialog<double?>(
                context: context,
                builder: (context) => InitiativeDialog(combatant: combatant),
              );

              if (value != null) {
                onInitiativeChanged?.call(value);
              }
            },
            child: Text(combatant.initiative.toStringAsFixed(1)),
          ),
          const SizedBox(width: 8),
          Text(combatant.name),
          const SizedBox(width: 8),
          Text("${combatant.currentHp}/${combatant.maxHp}"),
          const Spacer(),
          _Armor(
            armorClass: combatant.armorClass,
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    return selected ? theme.colorScheme.secondary : theme.primaryColor;
  }

  Color _getTileColor(BuildContext context, int index) {
    final theme = Theme.of(context);
    final opacity = index.isEven ? 0.15 : 0.05;
    return theme.primaryColor.withOpacity(opacity);
  }
}

class _Armor extends StatelessWidget {
  const _Armor({
    required this.armorClass,
  });

  final int armorClass;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.shield, color: Colors.grey.shade700),
        Text(
          "$armorClass",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
