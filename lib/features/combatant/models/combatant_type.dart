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
