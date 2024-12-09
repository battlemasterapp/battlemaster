import 'package:battlemaster/features/combatant/widgets/combatant_details/combatant_details.dart';
import 'package:battlemaster/flavors/pf2e/pf2e_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../combatant/models/combatant.dart';

class EncounterDetailsPanel extends StatelessWidget {
  const EncounterDetailsPanel({
    super.key,
    this.combatant,
    this.open = false,
    this.onClose,
  });

  final bool open;
  final Combatant? combatant;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    if (open) {
      assert(combatant != null);
    }

    return AnimatedSwitcher(
      duration: 300.ms,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) => SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: animation,
        child: child,
      ),
      child: !open
          ? SizedBox.shrink()
          : DefaultTextStyle(
              style: const TextStyle(
                color: Colors.black,
              ),
              child: FractionallySizedBox(
                widthFactor: .3,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: parchment,
                    border: Border(
                      left: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton.outlined(
                            color: Colors.black,
                            onPressed: () => onClose?.call(),
                            icon: Icon(Icons.close),
                          ),
                        ),
                        CombatantDetails(combatant: combatant!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
