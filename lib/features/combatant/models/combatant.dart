import 'dart:math';

import 'package:battlemaster/features/combatant/models/combatant_data.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../engines/models/game_engine_type.dart';
import 'combatant_type.dart';
import 'dnd5e_combatant_data.dart';

part 'combatant.g.dart';

@JsonSerializable()
class Combatant extends Equatable {
  final String id;
  final String name;
  final int currentHp;
  final int maxHp;
  final double initiative;
  final int armorClass;
  final int initiativeModifier;
  final double? level;
  final CombatantType type;
  final GameEngineType engineType;
  final List<Condition> conditions;

  @JsonKey(
    fromJson: combatantDataFromJson,
    toJson: combatantDataToJson,
  )
  final CombatantData? combatantData;

  const Combatant({
    this.id = "",
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.armorClass,
    required this.initiativeModifier,
    required this.type,
    required this.engineType,
    this.conditions = const [],
    this.initiative = 0,
    this.combatantData,
    this.level,
  });

  bool get isAlive => currentHp > 0;

  bool get isPlayer => type == CombatantType.player;

  factory Combatant.fromCombatantData(CombatantData data) {
    if (data is Pf2eCombatantData) {
      return Combatant.fromPf2eCombatantData(data);
    }
    if (data is Dnd5eCombatantData) {
      return Combatant.from5eCombatantData(data);
    }
    throw UnimplementedError();
  }

  factory Combatant.fromPf2eCombatantData(Pf2eCombatantData data) {
    return Combatant(
      name: data.name,
      currentHp: data.hp,
      maxHp: data.hp,
      armorClass: data.ac,
      initiativeModifier: data.initiativeModifier,
      combatantData: data,
      level: data.level.toDouble(),
      type: CombatantType.monster,
      engineType: GameEngineType.pf2e,
    );
  }

  factory Combatant.from5eCombatantData(Dnd5eCombatantData data) {
    return Combatant(
      name: data.name,
      currentHp: data.hp,
      maxHp: data.hp,
      armorClass: data.ac,
      initiativeModifier: data.initiativeModifier,
      combatantData: data,
      level: data.level,
      type: CombatantType.monster,
      engineType: GameEngineType.dnd5e,
    );
  }

  factory Combatant.fromJson(Map<String, dynamic> json) =>
      _$CombatantFromJson(json);

  Map<String, dynamic> toJson() => _$CombatantToJson(this);

  Map<String, dynamic> toShortJson() => toJson()..['combatantData'] = {};

  Combatant updateCombatantData(CombatantData data) {
    final updated = Combatant.fromCombatantData(data);
    return updated.copyWith(
      id: id,
      currentHp: min(currentHp, updated.maxHp),
      conditions: conditions,
      initiative: initiative,
    );
  }

  Combatant copyWith({
    String? id,
    String? name,
    int? currentHp,
    int? maxHp,
    double? initiative,
    int? armorClass,
    int? initiativeModifier,
    double? level,
    CombatantType? type,
    GameEngineType? engineType,
    List<Condition>? conditions,
  }) {
    return Combatant(
      id: id ?? this.id,
      name: name ?? this.name,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      initiative: initiative ?? this.initiative,
      armorClass: armorClass ?? this.armorClass,
      initiativeModifier: initiativeModifier ?? this.initiativeModifier,
      level: level ?? this.level,
      type: type ?? this.type,
      engineType: engineType ?? this.engineType,
      conditions: conditions ?? this.conditions,
      combatantData: combatantData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        engineType,
      ];
}

CombatantData? combatantDataFromJson(Map<String, dynamic> json) {
  final engine = json['engine'] as String?;
  if (engine == null) {
    return null;
  }
  return engine == 'dnd5e'
      ? Dnd5eCombatantData.fromJson(json)
      : Pf2eCombatantData.fromJson(json);
}

Map<String, dynamic> combatantDataToJson(CombatantData? instance) {
  return instance?.toJson() ?? {};
}
