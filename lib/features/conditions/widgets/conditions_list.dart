import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConditionChip extends StatelessWidget {
  const ConditionChip({
    super.key,
    required this.condition,
    this.onDeleted,
  });

  final Condition condition;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    String label = condition.name;
    if (condition.value != null) {
      label += ' ${condition.value}';
    }
    if (condition.durationRounds != null) {
      label +=
          ' ${localization.condition_duration_round(condition.durationRounds!)}';
    }

    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
    );
  }
}

class ConditionsList extends StatelessWidget {
  const ConditionsList({super.key, this.conditions = const []});

  final List<Condition> conditions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final condition in conditions) ConditionChip(condition: condition),
      ],
    );
  }
}
