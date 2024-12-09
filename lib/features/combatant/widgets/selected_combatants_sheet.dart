import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/selected_combatants.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectedCombatantsBottomSheet extends StatelessWidget {
  const SelectedCombatantsBottomSheet({
    super.key,
    this.combatants = const {},
    this.onCombatantsChanged,
  });

  final ValueChanged<Map<Combatant, int>>? onCombatantsChanged;
  final Map<Combatant, int> combatants;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final child = SelectedCombatants(
      combatants: combatants,
      onCombatantsChanged: onCombatantsChanged,
    );
    return DraggableBottomSheet(
      backgroundWidget: Container(),
      previewWidget: _Sheet(
        combatants: combatants,
        child: child,
      ),
      expandedWidget: _Sheet(
        combatants: combatants,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: child),
            Row(
              children: [
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(localization.cancel_button),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(combatants);
                  },
                  child: Text(localization.save_button),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
      onDragging: (_) {},
      barrierDismissible: true,
      useSafeArea: true,
      maxExtent: MediaQuery.of(context).size.height * 0.8,
      minExtent: 100,
      duration: 100.ms,
      curve: Curves.easeInOut,
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.child,
    this.combatants = const {},
  });

  final Widget child;
  final Map<Combatant, int> combatants;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                width: 50,
                height: 5,
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
