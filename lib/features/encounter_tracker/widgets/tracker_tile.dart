import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/hp_dialog.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/initiative_dialog.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/remove_combatant_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ionicons/ionicons.dart';

import '../../combatant/models/combatant.dart';

class TrackerTile extends StatelessWidget {
  const TrackerTile({
    super.key,
    required this.combatant,
    required this.index,
    this.selected = false,
    this.onInitiativeChanged,
    this.onHealthChanged,
    this.onRemove,
    this.onTap,
  });

  final bool selected;
  final Combatant combatant;
  final int index;
  final ValueChanged<double>? onInitiativeChanged;
  final ValueChanged<int>? onHealthChanged;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              TextButton(
                onPressed: () async {
                  final value = await showDialog<double?>(
                    context: context,
                    builder: (context) =>
                        InitiativeDialog(combatant: combatant),
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
              _Health(
                combatant: combatant,
                onHealthChanged: onHealthChanged,
              ),
              const Spacer(),
              _Armor(
                armorClass: combatant.armorClass,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => RemoveCombatantDialog(
                      name: combatant.name,
                    ),
                  );

                  if (confirm == null || !confirm) {
                    return;
                  }
                  onRemove?.call();
                },
                icon: Icon(Icons.delete),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    return selected
        ? theme.colorScheme.secondary
        : theme.primaryColor.withOpacity(.5);
  }

  Color _getTileColor(BuildContext context, int index) {
    final theme = Theme.of(context);
    final opacity = index.isEven ? 0.15 : 0.05;
    return theme.colorScheme.primary.withOpacity(opacity);
  }
}

class _Health extends StatelessWidget {
  const _Health({
    required this.combatant,
    this.onHealthChanged,
  });

  final ValueChanged<int>? onHealthChanged;
  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    var healthString = "";
    if (combatant.maxHp > 0) {
      healthString += "/${combatant.maxHp}";
    }

    final color = getColor();

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 2,
          color: color,
        ),
      ),
      onPressed: () async {
        final health = await showDialog(
          context: context,
          builder: (context) => HpDialog(combatant: combatant),
        );

        if (health == null) {
          return;
        }
        onHealthChanged?.call(health);
      },
      icon: Icon(
        getIcon(),
        color: color,
      ),
      label: Row(
        children: [
          AnimatedFlipCounter(
            value: combatant.currentHp,
            duration: 500.ms,
            curve: Curves.easeInOutExpo,
            textStyle: TextStyle(color: color),
          ),
          Text(
            healthString,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  IconData getIcon() {
    final currentHealth = combatant.currentHp;
    final halfHealth = (currentHealth / max(combatant.maxHp, 1)) <= 0.5;

    if (currentHealth == 0) {
      return Ionicons.skull;
    }

    return halfHealth ? Icons.heart_broken : Icons.favorite;
  }

  Color getColor() {
    const fullHealthColor = Colors.green;
    const deadColor = Colors.red;

    final currentHealth = combatant.currentHp;

    if (currentHealth == 0) {
      return deadColor;
    }

    return Color.lerp(
      fullHealthColor,
      deadColor,
      1 - (currentHealth / max(combatant.maxHp, currentHealth)),
    )!;
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
