import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      // FIXME: textos
      title: Text('Criar condição'),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                  onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descrição é obrigatória';
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
            Navigator.of(context).pop();
          },
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(CustomCondition(
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
