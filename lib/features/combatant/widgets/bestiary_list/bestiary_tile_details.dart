import 'package:battlemaster/features/combatant/models/pf2e_combatant_data.dart';
import 'package:flutter/material.dart';

import '../../../engines/models/game_engine_type.dart';
import '../../models/combatant.dart';
import '../traits.dart';

class BestiaryTileDetails extends StatelessWidget {
  const BestiaryTileDetails({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.engineType != GameEngineType.pf2e) {
      return Container();
    }

    return PF2eBestiaryTileDetails(
        combatant: combatant.combatantData as Pf2eCombatantData);
  }
}

class PF2eBestiaryTileDetails extends StatelessWidget {
  const PF2eBestiaryTileDetails({
    super.key,
    required this.combatant,
  });

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    return Traits(
      traits: combatant.traits,
    );
  }
}
