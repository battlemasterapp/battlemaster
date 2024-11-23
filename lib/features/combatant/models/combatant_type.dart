import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

enum CombatantType {
  player,
  monster,
  hazard,
  lair,
}

extension CombatantTypeIcon on CombatantType {
  FIconObject get icon {
    switch (this) {
      case CombatantType.player:
        return GI.GiVisoredHelm;
      case CombatantType.monster:
        return GI.GiSpikedDragonHead;
      case CombatantType.hazard:
        return GI.GiWolfTrap;
      case CombatantType.lair:
        return GI.GiStalactites;
    }
  }
}

extension Translate on CombatantType {
  String translate(AppLocalizations localization) {
    switch (this) {
      case CombatantType.player:
        return localization.combatant_type_player;
      case CombatantType.monster:
        return localization.combatant_type_monster;
      case CombatantType.hazard:
        return localization.combatant_type_hazard;
      case CombatantType.lair:
        return localization.combatant_type_lair;
    }
  }
}