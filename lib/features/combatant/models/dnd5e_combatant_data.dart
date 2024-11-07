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
}
