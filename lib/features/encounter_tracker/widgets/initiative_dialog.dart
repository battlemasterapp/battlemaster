import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../combatant/models/combatant.dart';

class InitiativeDialog extends StatefulWidget {
  const InitiativeDialog({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  State<InitiativeDialog> createState() => _InitiativeDialogState();
}

class _InitiativeDialogState extends State<InitiativeDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.combatant.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.initiative_input_label,
            ),
            onSubmitted: (value) {
              Navigator.of(context).pop(double.tryParse(value));
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(double.tryParse(_controller.text));
          },
          child: Text(AppLocalizations.of(context)!.save_button),
        ),
      ],
    );
  }
}
