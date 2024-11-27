import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/conditions/providers/conditions_provider.dart';
import 'package:battlemaster/features/conditions/widgets/add_condition_dialog.dart';
import 'package:battlemaster/features/conditions/widgets/conditions_list.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AddConditionButton extends StatelessWidget {
  const AddConditionButton({
    super.key,
    required this.engine,
    this.onConditionsAdded,
    this.conditions = const [],
  });

  final ValueChanged<List<Condition>>? onConditionsAdded;
  final List<Condition> conditions;
  final GameEngineType engine;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final analytics = context.read<AnalyticsService>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final condition in conditions)
          ConditionChip(
            condition: condition,
            showDeleteIcon: true,
            onDeleted: () {
              onConditionsAdded?.call(conditions..remove(condition));
            },
          ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () async {
            final selectedConditions = await showDialog<List<Condition>?>(
              context: context,
              builder: (context) => ChangeNotifierProvider<ConditionsProvider>(
                create: (context) =>
                    ConditionsProvider(context.read<AppDatabase>()),
                child: AddConditionDialog(
                  conditions: conditions,
                  engine: engine,
                ),
              ),
            );

            if (selectedConditions != null) {
              onConditionsAdded?.call(selectedConditions);
              await analytics.logEvent(
                'add_conditions',
                props: {
                  'conditions_count': selectedConditions.length.toString(),
                },
              );
            }
          },
          icon: Icon(MingCute.add_fill),
          label: Text(localization.add_condition_button),
        ),
      ],
    );
  }
}
