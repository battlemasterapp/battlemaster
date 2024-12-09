import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      combatant.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Spacer(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _updateCombatants(combatant, count - 1),
                            icon: Icon(MingCute.minus_circle_fill),
                          ),
                          Text(count.toString()),
                          IconButton(
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
