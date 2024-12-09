import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

class HpDialog extends StatefulWidget {
  const HpDialog({
    super.key,
    required this.currentHp,
    this.maxHp = 0,
  });

  final int currentHp;
  final int maxHp;

  @override
  State<HpDialog> createState() => _HpDialogState();
}

class _HpDialogState extends State<HpDialog> {
  final _controller = TextEditingController();
  late int health;
  late int maxHp;

  @override
  void initState() {
    maxHp = max(widget.maxHp, 0);
    if (maxHp == 0) {
      maxHp = 999;
    }
    health = max(min(widget.currentHp, maxHp), 0);
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
                  key: const Key('-10-hp'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(-10),
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  label: const Text("-10"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  key: const Key('-5-hp'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(-5),
                  icon: Icon(Icons.keyboard_arrow_left),
                  label: const Text("-5"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  key: const Key('+5-hp'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(5),
                  icon: Icon(Icons.keyboard_arrow_right),
                  label: const Text("+5"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  key: const Key('+10-hp'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => applyModifier(10),
                  icon: Icon(Icons.keyboard_double_arrow_right),
                  label: const Text("+10"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    final value = int.tryParse(_controller.text) ?? 0;
                    applyModifier(value * -1);
                    _controller.clear();
                  },
                  icon: Icon(MingCute.heart_crack_fill),
                  label: Text(AppLocalizations.of(context)!.damage_button),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "15",
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    applyModifier(int.tryParse(_controller.text) ?? 0);
                    _controller.clear();
                  },
                  icon: Icon(MingCute.heart_fill),
                  label: Text(AppLocalizations.of(context)!.heal_button),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, widget.currentHp);
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
