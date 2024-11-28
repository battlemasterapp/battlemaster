import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/conditions/widgets/conditions_list.dart';
import 'package:battlemaster/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ultimate_flutter_icons/ficon.dart';

class LiveViewTile extends StatelessWidget {
  const LiveViewTile({
    super.key,
    required this.combatant,
    required this.index,
    this.selected = false,
    this.revealed = true,
    this.showMonsterHealth = true,
    this.showPlayersHealth = true,
  });

  final Combatant combatant;
  final int index;
  final bool selected;
  final bool revealed;
  final bool showMonsterHealth;
  final bool showPlayersHealth;

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
            if (revealed) ...[
              FIcon(
                combatant.type.icon,
                color: Theme.of(context).iconTheme.color ??
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    Colors.black,
              ),
              const SizedBox(width: 8),
            ],
            revealed ? Text(combatant.name) : Text('???'),
            const SizedBox(width: 8),
            _CombatantHealth(
              combatant: combatant,
              revealed: revealed,
              showMonsterHealth: showMonsterHealth,
              showPlayersHealth: showPlayersHealth,
            ),
          ],
        ),
        subtitle: combatant.conditions.isNotEmpty && revealed
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ConditionsList(
                  conditions: combatant.conditions,
                ),
              )
            : null,
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
    this.revealed = true,
    this.showMonsterHealth = true,
    this.showPlayersHealth = true,
  });

  final Combatant combatant;
  final bool revealed;
  final bool showMonsterHealth;
  final bool showPlayersHealth;

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
    if (combatant.type == CombatantType.player) {
      if (!showPlayersHealth) {
        return const SizedBox();
      }

      return Container(
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Icon(
              getIcon(),
              color: color,
              size: 18,
            ),
            const SizedBox(width: 4),
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

    if (!revealed) {
      return const SizedBox();
    }

    if (!showMonsterHealth) {
      return const SizedBox();
    }

    final localization = AppLocalizations.of(context)!;
    final thresholds = <double, String>{
      0.75: localization.health_indicator_healthy,
      0.5: localization.health_indicator_hurt,
      0.25: localization.health_indicator_bloodied,
      0: localization.health_indicator_critical,
    };

    final healthThreshold = thresholds.entries.firstWhere(
      (entry) => combatant.currentHp / combatant.maxHp > entry.key,
      orElse: () => MapEntry(0, localization.health_indicator_dead),
    );

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(
            getIcon(),
            color: color,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            healthThreshold.value,
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
      return MingCute.skull_fill;
    }

    return halfHealth ? MingCute.heart_crack_fill : MingCute.heart_fill;
  }
}
