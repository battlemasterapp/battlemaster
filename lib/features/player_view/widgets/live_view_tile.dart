import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/conditions/widgets/conditions_list.dart';
import 'package:battlemaster/features/player_view/widgets/live_view_health.dart';
import 'package:flutter/material.dart';
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
            LiveViewHealth(
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
