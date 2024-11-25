import 'dart:math';

import 'package:battlemaster/features/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
        context.pop(health);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final portraitLayout = constraints.maxWidth < 520;
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.hp_dialog_title(health)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: health.toDouble(),
                max: maxHp.toDouble(),
                activeColor: getHealthColor(
                  health,
                  maxHp: maxHp,
                ),
                onChanged: (value) {
                  setState(() {
                    health = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 8),
              _QuickAdjustmentButtons(
                portraitLayout: portraitLayout,
                onAdjustment: applyModifier,
              ),
              const Divider(),
              const SizedBox(height: 16),
              _DamageField(
                portraitLayout: portraitLayout,
                textController: _controller,
                onDamage: applyModifier,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(widget.currentHp);
              },
              child: Text(AppLocalizations.of(context)!.cancel_button),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop(health);
              },
              child: Text(AppLocalizations.of(context)!.save_button),
            ),
          ],
        );
      }),
    );
  }

  void applyModifier(int mod) {
    setState(() {
      health += mod;
      health = max(min(health, maxHp), 0);
    });
  }
}

class _QuickAdjustmentButtons extends StatelessWidget {
  const _QuickAdjustmentButtons({
    required this.onAdjustment,
    this.portraitLayout = false,
  });

  final bool portraitLayout;
  final ValueChanged<int> onAdjustment;

  @override
  Widget build(BuildContext context) {
    if (portraitLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                key: const Key('-10-hp'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => onAdjustment(-10),
                icon: Icon(MingCute.arrows_left_fill),
                label: const Text("-10"),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                key: const Key('+10-hp'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => onAdjustment(10),
                icon: Icon(MingCute.arrows_right_fill),
                label: const Text("+10"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                key: const Key('-5-hp'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => onAdjustment(-5),
                icon: Icon(MingCute.left_fill),
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
                onPressed: () => onAdjustment(5),
                icon: Icon(MingCute.right_fill),
                label: const Text("+5"),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        ElevatedButton.icon(
          key: const Key('-10-hp'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () => onAdjustment(-10),
          icon: Icon(MingCute.arrows_left_fill),
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
          onPressed: () => onAdjustment(-5),
          icon: Icon(MingCute.left_fill),
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
          onPressed: () => onAdjustment(5),
          icon: Icon(MingCute.right_fill),
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
          onPressed: () => onAdjustment(10),
          icon: Icon(MingCute.arrows_right_fill),
          label: const Text("+10"),
        ),
      ],
    );
  }
}

class _DamageField extends StatelessWidget {
  const _DamageField({
    required this.onDamage,
    required this.textController,
    this.portraitLayout = false,
  });

  final bool portraitLayout;
  final TextEditingController textController;
  final ValueChanged<int> onDamage;

  @override
  Widget build(BuildContext context) {
    if (portraitLayout) {
      return Column(
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "15",
              label: Text(AppLocalizations.of(context)!.hp_dialog_input),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: false,
            ),
            onSubmitted: (value) {
              onDamage(int.tryParse(value) ?? 0);
              textController.clear();
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  final value = int.tryParse(textController.text) ?? 0;
                  onDamage(value * -1);
                  textController.clear();
                },
                icon: Icon(MingCute.heart_crack_fill),
                label: Text(AppLocalizations.of(context)!.damage_button),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  onDamage(int.tryParse(textController.text) ?? 0);
                  textController.clear();
                },
                icon: Icon(MingCute.heart_fill),
                label: Text(AppLocalizations.of(context)!.heal_button),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            final value = int.tryParse(textController.text) ?? 0;
            onDamage(value * -1);
            textController.clear();
          },
          icon: Icon(MingCute.heart_crack_fill),
          label: Text(AppLocalizations.of(context)!.damage_button),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "15",
              label: Text(AppLocalizations.of(context)!.hp_dialog_input),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: false,
            ),
            onSubmitted: (value) {
              onDamage(int.tryParse(value) ?? 0);
              textController.clear();
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
            onDamage(int.tryParse(textController.text) ?? 0);
            textController.clear();
          },
          icon: Icon(MingCute.heart_fill),
          label: Text(AppLocalizations.of(context)!.heal_button),
        ),
      ],
    );
  }
}
