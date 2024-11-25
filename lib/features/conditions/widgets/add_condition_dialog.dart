import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/conditions/providers/conditions_provider.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AddConditionDialog extends StatefulWidget {
  const AddConditionDialog({
    super.key,
    this.conditions = const [],
    required this.engine,
  });

  final List<Condition> conditions;
  final GameEngineType engine;

  @override
  State<AddConditionDialog> createState() => _AddConditionDialogState();
}

class _AddConditionDialogState extends State<AddConditionDialog> {
  final _activeConditions = <Condition>[];
  final List<Condition> _allConditions = [];
  String _search = '';

  @override
  void initState() {
    super.initState();
    _activeConditions.addAll(widget.conditions);
    final settings = context.read<SystemSettingsProvider>();
    if (settings.dnd5eSettings.enabled ||
        widget.engine == GameEngineType.dnd5e) {
      _allConditions.addAll(context.read<Dnd5eEngineProvider>().conditions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final activeConditionsNames = _activeConditions.map((e) => e.name).toSet();
    return FutureBuilder<List<CustomCondition>>(
        future: context.read<ConditionsProvider>().getConditions(),
        builder: (context, snapshot) {
          final conditions = _allConditions +
              (snapshot.data ?? []).map(Condition.fromCustomCondition).toList();
          conditions.sort((a, b) => a.name.compareTo(b.name));
          if (widget.engine != GameEngineType.custom) {
            conditions.removeWhere((c) =>
                c.engine != widget.engine && c.engine != GameEngineType.custom);
          }
          final filteredConditions = conditions
              .where(
                  (c) => c.name.toLowerCase().contains(_search.toLowerCase()))
              .toList();
          return AlertDialog(
            title: Text(localization.add_condition_title),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => setState(() => _search = value),
                    decoration: InputDecoration(
                      labelText: localization.search_input,
                      prefixIcon: Icon(MingCute.search_fill),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final condition in filteredConditions)
                            CheckboxListTile(
                              value: activeConditionsNames
                                  .contains(condition.name),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _activeConditions.add(condition);
                                  } else {
                                    _activeConditions.removeWhere(
                                        (e) => e.name == condition.name);
                                  }
                                });
                              },
                              title: Text(condition.name),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(localization.cancel_button),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop(_activeConditions);
                },
                child: Text(localization.save_button),
              ),
            ],
          );
        });
  }
}
