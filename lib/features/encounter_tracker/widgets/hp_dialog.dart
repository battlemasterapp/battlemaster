import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../combatant/models/combatant.dart';

class HpDialog extends StatefulWidget {
  const HpDialog({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  State<HpDialog> createState() => _HpDialogState();
}

class _HpDialogState extends State<HpDialog> {
  final _controller = TextEditingController();
  late int health;
  late int maxHp;

  @override
  void initState() {
    maxHp = max(widget.combatant.maxHp, 0);
    if (maxHp == 0) {
      maxHp = 999;
    }
    health = max(min(widget.combatant.currentHp, maxHp), 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, health);
      },
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.hp_dialog_title(health)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: health.toDouble(),
              max: maxHp.toDouble(),
              onChanged: (value) {
                setState(() {
                  health = value.toInt();
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(-10),
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  label: Text("-10"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(-5),
                  icon: Icon(Icons.keyboard_arrow_left),
                  label: Text("-5"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(5),
                  icon: Icon(Icons.keyboard_arrow_right),
                  label: Text("+5"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(10),
                  icon: Icon(Icons.keyboard_double_arrow_right),
                  label: Text("+10"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "-15",
                      label:
                          Text(AppLocalizations.of(context)!.hp_dialog_input),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: false,
                    ),
                    onSubmitted: (value) {
                      applyModifier(int.tryParse(value) ?? 0);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    applyModifier(int.tryParse(_controller.text) ?? 0);
                    _controller.clear();
                  },
                  child: Text(AppLocalizations.of(context)!.apply_button),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, widget.combatant.currentHp);
            },
            child: Text(AppLocalizations.of(context)!.cancel_button),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, health);
            },
            child: Text(AppLocalizations.of(context)!.save_button),
          ),
        ],
      ),
    );
  }

  void applyModifier(int mod) {
    setState(() {
      health += mod;
      health = max(min(health, maxHp), 0);
    });
  }
}