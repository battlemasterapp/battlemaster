import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../engines/models/game_engine_type.dart';
import '../../models/combatant.dart';
import '../../models/dnd5e_combatant_data.dart';
import '../traits.dart';

class BestiaryTileDetails extends StatelessWidget {
  const BestiaryTileDetails({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.engineType == GameEngineType.dnd5e) {
      return Dnd5eBestiaryTileDetails(
        combatant: combatant.combatantData as Dnd5eCombatantData,
      );
    }

    if (combatant.engineType == GameEngineType.pf2e) {
      return PF2eBestiaryTileDetails(
          combatant: combatant.combatantData as Pf2eCombatantData);
    }

    return CustomBestiaryTileDetails(combatant: combatant);
  }
}

class CustomBestiaryTileDetails extends StatelessWidget {
  const CustomBestiaryTileDetails({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Text(combatant.type.translate(localization));
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

class Dnd5eBestiaryTileDetails extends StatelessWidget {
  const Dnd5eBestiaryTileDetails({
    super.key,
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final texts = [
      combatant.size,
      combatant.type,
      if (combatant.subtype.isNotEmpty) "(${combatant.subtype})",
    ].nonNulls.toList().join(" ");
    return Text("$texts, ${combatant.alignment} (${combatant.source})");
  }
}
