import 'package:battlemaster/features/combatant/models/pf2e_combatant_data.dart';
import 'package:flutter/material.dart';

import '../../../engines/models/game_engine_type.dart';
import '../../models/combatant.dart';
import 'bestiary_tile_details.dart';

class BestiaryListTile extends StatelessWidget {
  const BestiaryListTile({
    super.key,
    required this.combatant,
    this.onTap,
    this.tileColor,
  });

  final Combatant combatant;
  final Color? tileColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: tileColor,
      title: BestiaryTileTitle(combatant: combatant),
      subtitle: BestiaryTileDetails(combatant: combatant),
      trailing: combatant.level != null
          ? Text(
              combatant.level.toString(),
              style: Theme.of(context).textTheme.labelLarge,
            )
          : null,
    );
  }
}

class BestiaryTileTitle extends StatelessWidget {
  const BestiaryTileTitle({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.engineType == GameEngineType.pf2e) {
      return Text(
          "${combatant.name} (${(combatant.combatantData! as Pf2eCombatantData).source})");
    }
    return Text(combatant.name);
  }
}
