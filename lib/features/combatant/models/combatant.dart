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
  final int? level;
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
    this.level,
  });

  factory Combatant.fromJson(Map<String, dynamic> json) =>
      _$CombatantFromJson(json);

  Map<String, dynamic> toJson() => _$CombatantToJson(this);

  Combatant copyWith({
    String? name,
    int? currentHp,
    int? maxHp,
    int? initiative,
    int? armorClass,
    int? initiativeModifier,
    int? level,
    CombatantType? type,
    GameEngineType? engineType,
    CombatantData? combatantData,
  }) {
    return Combatant(
      name: name ?? this.name,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      initiative: initiative ?? this.initiative,
      armorClass: armorClass ?? this.armorClass,
      initiativeModifier: initiativeModifier ?? this.initiativeModifier,
      level: level ?? this.level,
      type: type ?? this.type,
      engineType: engineType ?? this.engineType,
      combatantData: combatantData ?? this.combatantData,
    );
  }

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
