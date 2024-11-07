import 'package:battlemaster/features/combatant/models/pf2e_combatant_data.dart';
import 'package:flutter/material.dart';

import '../../../engines/models/game_engine_type.dart';
import '../../models/combatant.dart';
import '../../models/dnd5e_combatant_data.dart';
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
    return Container(
      color: tileColor,
      child: ListTile(
        onTap: onTap,
        title: BestiaryTileTitle(combatant: combatant),
        subtitle: BestiaryTileDetails(combatant: combatant),
        trailing: BestiaryTileLevel(combatant: combatant),
      ),
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

class BestiaryTileLevel extends StatelessWidget {
  const BestiaryTileLevel({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.level == null) {
      return Container();
    }

    if (combatant.engineType == GameEngineType.dnd5e) {
      final cr =
          (combatant.combatantData! as Dnd5eCombatantData).challengeRating;
      return Text(
        "CR $cr",
        style: Theme.of(context).textTheme.labelLarge,
      );
    }

    return Text(
      combatant.level!.toStringAsFixed(0),
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
