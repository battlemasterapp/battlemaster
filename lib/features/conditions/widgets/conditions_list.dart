import 'package:badges/badges.dart' as badges;
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/conditions/widgets/condition_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ConditionChip extends StatelessWidget {
  const ConditionChip({
    super.key,
    required this.condition,
    this.showDeleteIcon = false,
    this.onDeleted,
  }) : assert(showDeleteIcon || onDeleted == null);

  final Condition condition;
  final VoidCallback? onDeleted;
  final bool showDeleteIcon;

  @override
  Widget build(BuildContext context) {
    if (condition.durationRounds != null) {
      return badges.Badge(
        badgeContent: Text(
          condition.durationRounds.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: _RawConditionChip(
          condition: condition,
          onDeleted: onDeleted,
          showDeleteIcon: showDeleteIcon,
        ),
      );
    }

    return _RawConditionChip(
      condition: condition,
      onDeleted: onDeleted,
      showDeleteIcon: showDeleteIcon,
    );
  }
}

class _RawConditionChip extends StatelessWidget {
  const _RawConditionChip({
    required this.condition,
    this.showDeleteIcon = false,
    this.onDeleted,
  });

  final Condition condition;
  final VoidCallback? onDeleted;
  final bool showDeleteIcon;

  @override
  Widget build(BuildContext context) {
    String label = condition.name;
    if (condition.value != null) {
      label += ' ${condition.value}';
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => ConditionInfoDialog(
              condition: condition,
              onDeleted: onDeleted,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              if (showDeleteIcon) buildDeleteIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeleteIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: IconButton.outlined(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(24, 24),
          alignment: Alignment.center,
        ),
        icon: Icon(
          MingCute.close_fill,
          size: 16,
        ),
        onPressed: onDeleted,
      ),
    );
  }
}

class ConditionsList extends StatelessWidget {
  const ConditionsList({
    super.key,
    this.conditions = const [],
    this.onDeleted,
  });

  final List<Condition> conditions;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      children: [
        for (final condition in conditions)
          ConditionChip(
            condition: condition,
            onDeleted: onDeleted,
          ),
      ],
    );
  }
}
