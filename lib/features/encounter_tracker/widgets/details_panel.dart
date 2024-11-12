import 'package:battlemaster/features/combatant/widgets/combatant_details/combatant_details.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/flavors/pf2e/pf2e_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../combatant/models/combatant.dart';

class EncounterDetailsPanel extends StatelessWidget {
  const EncounterDetailsPanel({
    super.key,
    this.combatant,
    this.open = false,
    this.onClose,
    this.onConditionsAdded,
  });

  final bool open;
  final Combatant? combatant;
  final VoidCallback? onClose;
  final ValueChanged<List<Condition>>? onConditionsAdded;

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton.outlined(
                              color: Colors.black,
                              onPressed: () => onClose?.call(),
                              icon: Icon(MingCute.close_fill),
                            ),
                          ),
                          CombatantDetails(
                            combatant: combatant!,
                            onConditionsAdded: onConditionsAdded,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
