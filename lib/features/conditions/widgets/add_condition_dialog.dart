import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AddConditionDialog extends StatefulWidget {
  const AddConditionDialog({super.key, this.conditions = const []});

  final List<Condition> conditions;

  @override
  State<AddConditionDialog> createState() => _AddConditionDialogState();
}

class _AddConditionDialogState extends State<AddConditionDialog> {
  final _activeConditions = <Condition>[];
  late List<Condition> _allConditions;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _activeConditions.addAll(widget.conditions);
    _allConditions = context.read<Dnd5eEngineProvider>().conditions;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final activeConditionsNames = _activeConditions.map((e) => e.name).toSet();
    final _filteredConditions = _allConditions
        .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
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
                    for (final condition in _filteredConditions)
                      CheckboxListTile(
                        value: activeConditionsNames.contains(condition.name),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _activeConditions.add(condition);
                            } else {
                              _activeConditions
                                  .removeWhere((e) => e.name == condition.name);
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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_activeConditions);
          },
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}
