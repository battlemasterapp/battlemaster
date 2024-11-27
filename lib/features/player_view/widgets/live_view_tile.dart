import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LiveViewTile extends StatelessWidget {
  const LiveViewTile({
    super.key,
    required this.combatant,
    required this.index,
    this.selected = false,
    this.revealed = true,
  });

  final Combatant combatant;
  final int index;
  final bool selected;
  final bool revealed;

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
      child: ListTile(
        leading: Text(combatant.initiative.toStringAsFixed(1)),
        title: Row(
          children: [
            AnimatedSwitcher(
              duration: 1.seconds,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: revealed ? Text(combatant.name) : Text('???'),
            ),
            const SizedBox(width: 8),
            _CombatantHealth(combatant: combatant),
          ],
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
    final color = selected ? theme.colorScheme.secondary : theme.primaryColor;
    return color.withOpacity(opacity);
  }
}

class _CombatantHealth extends StatelessWidget {
  const _CombatantHealth({
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    var healthString = "";
    if (combatant.maxHp > 0) {
      healthString += "/${combatant.maxHp}";
    }
    final color = getHealthColor(
      combatant.currentHp,
      maxHp: combatant.maxHp,
    );
    // TODO: this should be in the system settings
    if (combatant.type == CombatantType.player) {
      return Container(
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
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

    return const SizedBox.shrink();
  }
}
