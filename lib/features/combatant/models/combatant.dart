import 'package:battlemaster/features/combatant/models/combatant_data.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../engines/models/game_engine_type.dart';
import 'combatant_type.dart';

part 'combatant.g.dart';

@JsonSerializable()
class Combatant extends Equatable {
  final String name;
  final int currentHp;
  final int maxHp;
  final int initiative;
  final int armorClass;
  final int initiativeModifier;
  final CombatantType type;
  final GameEngineType engineType;

  @JsonKey(
    fromJson: combatantDataFromJson,
    toJson: combatantDataToJson,
  )
  final CombatantData? combatantData;

  const Combatant({
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.armorClass,
    required this.initiativeModifier,
    required this.type,
    required this.engineType,
    this.initiative = 0,
    this.combatantData,
  });

  factory Combatant.fromJson(Map<String, dynamic> json) =>
      _$CombatantFromJson(json);

  Map<String, dynamic> toJson() => _$CombatantToJson(this);

  @override
  List<Object?> get props => [
        name,
        currentHp,
        maxHp,
        initiative,
        armorClass,
        initiativeModifier,
        type,
        engineType,
        combatantData,
      ];
}

CombatantData? combatantDataFromJson(Map<String, dynamic> json) {
  return null;
}

Map<String, dynamic> combatantDataToJson(CombatantData? instance) {
  return {};
}
