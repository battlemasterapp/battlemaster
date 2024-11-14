import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateConditionDialog extends StatelessWidget {
  const CreateConditionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      // FIXME: textos
      title: Text('Criar condição'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(localization.cancel_button),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: return value
            Navigator.of(context).pop();
          },
          child: Text(localization.save_button),
        ),
      ],
    );
  }
}
