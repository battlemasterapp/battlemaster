import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EncounterCodeDialog extends StatelessWidget {
  const EncounterCodeDialog({
    super.key,
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localization.encounter_code_dialog_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(localization.encounter_code_dialog_description),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localization.close_button),
        ),
      ],
    );
  }
}
