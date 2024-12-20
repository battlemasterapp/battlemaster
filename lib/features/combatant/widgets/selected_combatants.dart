import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

import '../models/combatant.dart';

class SelectedCombatants extends StatelessWidget {
  const SelectedCombatants({
    super.key,
    this.combatants = const {},
    this.onCombatantsChanged,
  });

  final Map<Combatant, int> combatants;
  final ValueChanged<Map<Combatant, int>>? onCombatantsChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (combatants.isNotEmpty)
              badges.Badge(
                badgeContent:
                    Text(combatants.values.reduce((a, b) => a + b).toString()),
                badgeAnimation: badges.BadgeAnimation.fade(
                  animationDuration: 150.ms,
                ),
                child: Text(
                  AppLocalizations.of(context)!.combatants_selected,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            if (combatants.isEmpty)
              Text(
                AppLocalizations.of(context)!.combatants_selected,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            Expanded(
              child: ListView.separated(
                itemCount: combatants.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final combatant = combatants.keys.elementAt(index);
                  final count = combatants.values.elementAt(index);

                  return Row(
                    key: const Key('combatants-list-tile'),
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        combatant.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: Row(
                          key: Key('${combatant.name}-count'),
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              key: const Key('remove-combatant'),
                              onPressed: () =>
                                  _updateCombatants(combatant, count - 1),
                              icon: Icon(MingCute.minus_circle_fill),
                            ),
                            Text(count.toString()),
                            IconButton(
                              key: const Key('add-combatant'),
                              onPressed: () =>
                                  _updateCombatants(combatant, count + 1),
                              icon: Icon(MingCute.add_circle_fill),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCombatants(Combatant combatant, int count) {
    if (count == 0) {
      combatants.remove(combatant);
    } else {
      combatants[combatant] = count;
    }
    onCombatantsChanged?.call(combatants);
  }
}
