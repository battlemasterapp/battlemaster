import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class ConditionInfoDialog extends StatelessWidget {
  const ConditionInfoDialog({
    super.key,
    required this.condition,
    this.onDeleted,
  });

  final Condition condition;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(condition.name),
          if (onDeleted != null)
            IconButton(
              icon: Icon(MingCute.delete_2_fill),
              onPressed: () {
                onDeleted?.call();
                context.pop();
              },
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            Text(condition.description),
          ],
        ),
      ),
    );
  }
}
