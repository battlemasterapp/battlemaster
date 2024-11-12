import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/material.dart';

class ConditionsList extends StatelessWidget {
  const ConditionsList({super.key, this.conditions = const []});

  final List<Condition> conditions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final condition in conditions)
        // TODO: format name
          Chip(
            label: Text(condition.name),
          ),
      ],
    );
  }
}
