import 'dart:math';

import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

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
          OutlinedButton.icon(
            onPressed: () async {
              final roll = Random().nextInt(20) +
                  1 +
                  widget.combatant.initiativeModifier;
              _controller.text = roll.toString();
              await context.read<AnalyticsService>().logEvent(
                'roll_single_initiative',
                props: {
                  'combatant_type': widget.combatant.type.toString(),
                },
              );
            },
            icon: Icon(FontAwesome.dice_d20_solid),
            label: Text(
              AppLocalizations.of(context)!.roll_initiative_button(
                  widget.combatant.initiativeModifier.signString),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
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
