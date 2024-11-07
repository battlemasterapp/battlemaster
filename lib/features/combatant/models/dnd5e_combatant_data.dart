import 'package:battlemaster/features/combatant/models/combatant_data.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dnd5e_combatant_data.g.dart';

@JsonSerializable()
class Dnd5eCombatantData extends CombatantData {
  Dnd5eCombatantData({
    super.engine = GameEngineType.dnd5e,
    super.rawData,
  });

  factory Dnd5eCombatantData.fromJson(Map<String, dynamic> json) =>
      _$Dnd5eCombatantDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Dnd5eCombatantDataToJson(this);

  String get name => rawData['name'] ?? "";

  int get hp => rawData['hit_points'] ?? 0;

  int get ac => rawData['armor_class'] ?? 0;

  int get initiativeModifier {
    final dex = rawData['dexterity'] as int? ?? 0;
    return ((dex - 10) / 2).floor();
  }

  double get level => rawData['cr'] ?? 0;

  String get challengeRating => rawData['challenge_rating'] ?? level.toString();

  String get source => rawData['document__title'] ?? '';

  String get size => rawData['size'] ?? '';

  String get type => rawData['type'] ?? '';

  String get subtype => rawData['subtype'] ?? '';

  String get alignment => rawData['alignment'] ?? '';

  Dnd5eCombatantSpeed get speed => Dnd5eCombatantSpeed(rawData['speed'] ?? {});

  Dnd5eAttribute get strength => Dnd5eAttribute(rawData['strength'] ?? 0);

  Dnd5eAttribute get dexterity => Dnd5eAttribute(rawData['dexterity'] ?? 0);

  Dnd5eAttribute get constitution => Dnd5eAttribute(rawData['constitution'] ?? 0);

  Dnd5eAttribute get intelligence => Dnd5eAttribute(rawData['intelligence'] ?? 0);

  Dnd5eAttribute get wisdom => Dnd5eAttribute(rawData['wisdom'] ?? 0);

  Dnd5eAttribute get charisma => Dnd5eAttribute(rawData['charisma'] ?? 0);

  String get damageVulnerabilities => rawData['damage_vulnerabilities'] ?? '';

  String get damageResistances => rawData['damage_resistances'] ?? '';

  String get damageImmunities => rawData['damage_immunities'] ?? '';

  String get conditionImmunities => rawData['condition_immunities'] ?? '';

  String get senses => rawData['senses'] ?? '';

  List<Dnd5eActions> get actions =>
      (rawData['actions'] as List<dynamic>?)
          ?.map((e) => Dnd5eActions(e as Map<String, dynamic>))
          .toList() ??
      [];

  List<Dnd5eAbility> get reactions =>
      (rawData['reactions'] as List<dynamic>?)
          ?.map((e) => Dnd5eAbility(e as Map<String, dynamic>))
          .toList() ??
      [];

  List<Dnd5eAbility> get specialAbilities =>
      (rawData['special_abilities'] as List<dynamic>?)
          ?.map((e) => Dnd5eAbility(e as Map<String, dynamic>))
          .toList() ??
      [];
}

class Dnd5eCombatantSpeed {
  final Map<String, dynamic> rawData;

  Dnd5eCombatantSpeed(this.rawData);

  int get walk => rawData['walk'] ?? 0;

  int get burrow => rawData['burrow'] ?? 0;

  int get climb => rawData['climb'] ?? 0;

  int get fly => rawData['fly'] ?? 0;

  int get swim => rawData['swim'] ?? 0;
}

class Dnd5eAttribute {
  final int attribute;
  final int modifier;

  Dnd5eAttribute(this.attribute) : modifier = ((attribute - 10) / 2).floor();
}

class Dnd5eAbility {
  final Map<String, dynamic> rawData;

  Dnd5eAbility(this.rawData);

  String get name => rawData['name'] ?? '';

  String get desc => rawData['desc'] ?? '';
}

class Dnd5eActions {
  final Map<String, dynamic> rawData;

  Dnd5eActions(this.rawData);

  String get name => rawData['name'] ?? '';

  String get desc => rawData['desc'] ?? '';

  int? get attackBonus => rawData['attack_bonus'] as int?;

  String get damageDice => rawData['damage_dice'] ?? '';
}
