import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

class LiveViewHealth extends StatelessWidget {
  const LiveViewHealth({
    super.key,
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
    final color = getHealthColor(
      combatant.currentHp,
      maxHp: combatant.maxHp,
    );
    final icon = getIcon();

    final isPlayer = combatant.type == CombatantType.player;

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isPlayer
          ? _PlayerHealth(
              combatant: combatant,
              showPlayersHealth: showPlayersHealth,
              icon: icon,
              color: color,
            )
          : _MonsterHealth(
              combatant: combatant,
              revealed: revealed,
              showMonsterHealth: showMonsterHealth,
              icon: icon,
              color: color,
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

class _PlayerHealth extends StatelessWidget {
  const _PlayerHealth({
    required this.combatant,
    required this.showPlayersHealth,
    required this.icon,
    required this.color,
  });

  final Combatant combatant;
  final bool showPlayersHealth;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (!showPlayersHealth) {
      return const SizedBox();
    }

    var healthString = "";
    if (combatant.maxHp > 0) {
      healthString += "/${combatant.maxHp}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
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
}

class _MonsterHealth extends StatelessWidget {
  const _MonsterHealth({
    required this.combatant,
    this.revealed = true,
    this.showMonsterHealth = true,
    required this.icon,
    required this.color,
  });

  final Combatant combatant;
  final bool revealed;
  final bool showMonsterHealth;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
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
}
