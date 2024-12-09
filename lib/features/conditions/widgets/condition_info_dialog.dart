import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class ConditionInfoDialog extends StatefulWidget {
  const ConditionInfoDialog({
    super.key,
    required this.condition,
    this.onDeleted,
    this.onValueChanged,
  });

  final Condition condition;
  final VoidCallback? onDeleted;
  final ValueChanged<int>? onValueChanged;

  @override
  State<ConditionInfoDialog> createState() => _ConditionInfoDialogState();
}

class _ConditionInfoDialogState extends State<ConditionInfoDialog> {
  late int value;
  late bool canEdit;

  @override
  void initState() {
    super.initState();
    canEdit = widget.onValueChanged != null;
    value = widget.condition.value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final hasValue = widget.condition.engine == GameEngineType.pf2e;
    final title =
        value > 0 ? '${widget.condition.name} $value' : widget.condition.name;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (widget.onDeleted != null)
            IconButton(
              icon: Icon(MingCute.delete_2_fill),
              onPressed: () {
                widget.onDeleted?.call();
                context.pop();
              },
            ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              SelectableText(widget.condition.description
                  .replaceAll("<p>", "")
                  .replaceAll("</p>", "")),
              const Divider(),
              if (hasValue && canEdit)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(localization.pf2e_condition_value_label),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(MingCute.minus_circle_fill),
                              onPressed: () {
                                if (value > 0) {
                                  widget.onValueChanged?.call(value - 1);
                                  setState(() {
                                    value--;
                                  });
                                }
                              },
                            ),
                            Text('$value'),
                            IconButton(
                              icon: Icon(MingCute.plus_fill),
                              onPressed: () {
                                widget.onValueChanged?.call(value + 1);
                                setState(() {
                                  value++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
