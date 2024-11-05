import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemoveCombatantDialog extends StatelessWidget {
  const RemoveCombatantDialog({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localization.remove_combatant_dialog_title),
      content: Text(localization.remove_combatant_dialog_content(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localization.no_button.toUpperCase()),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(localization.yes_button.toUpperCase()),
        ),
      ],
    );
  }
}
