import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/combatant.dart';

class SelectedCombatants extends StatelessWidget {
  const SelectedCombatants({
    super.key,
    this.combatants = const {},
  });

  final Map<Combatant, int> combatants;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.combatants_selected,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: combatants.length,
            itemBuilder: (context, index) {
              final combatant = combatants.keys.elementAt(index);
              final count = combatants.values.elementAt(index);

              return ListTile(
                title: Text(combatant.name),
                subtitle: Text(
                  "$count",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
