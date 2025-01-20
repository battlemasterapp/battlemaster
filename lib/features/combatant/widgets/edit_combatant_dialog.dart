import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_custom_combatant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class EditCombatantDialog extends StatelessWidget {
  const EditCombatantDialog({
    super.key,
    required this.combatant,
    required this.onEdit,
  });

  final Combatant combatant;
  final ValueChanged<Combatant> onEdit;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localization.edit_combatant_title(combatant.name)),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 300),
        child: SingleChildScrollView(
          child: CustomCombatantForm(
            showGroupReminder: false,
            onSubmit: (combatant) {
              onEdit(combatant);
              context.pop();
            },
            baseCombatant: combatant,
          ),
        ),
      ),
    );
  }
}
