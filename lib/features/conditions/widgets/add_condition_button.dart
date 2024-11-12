import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/conditions/widgets/add_condition_dialog.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AddConditionButton extends StatelessWidget {
  const AddConditionButton({
    super.key,
    this.onConditionsAdded,
    this.conditions = const [],
  });

  final ValueChanged<List<Condition>>? onConditionsAdded;
  final List<Condition> conditions;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () async {
        final selectedConditions = await showDialog<List<Condition>?>(
          context: context,
          builder: (context) => AddConditionDialog(conditions: conditions),
        );

        if (selectedConditions != null) {
          onConditionsAdded?.call(selectedConditions);
        }
      },
      icon: Icon(MingCute.add_fill),
      label: Text(localization.add_condition_button),
    );
  }
}
