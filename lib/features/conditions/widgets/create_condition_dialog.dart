import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CreateConditionDialog extends StatefulWidget {
  const CreateConditionDialog({super.key});

  @override
  State<CreateConditionDialog> createState() => _CreateConditionDialogState();
}

class _CreateConditionDialogState extends State<CreateConditionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localization.create_condition_dialog_title),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(labelText: localization.name_label),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.condition_name_validation_text;
                    }
                    return null;
                  },
                  onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: localization.description_label),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.condition_description_validation_text;
                    }
                    return null;
                  },
                  onChanged: (value) => _description = value,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            context.pop();
          },
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.pop(CustomCondition(
                id: -1,
                name: _name,
                description: _description,
                engine: GameEngineType.custom,
              ));
            }
          },
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}
