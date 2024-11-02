import 'package:json_annotation/json_annotation.dart';

part 'combatant_data.g.dart';

@JsonSerializable()
abstract class CombatantData {
  final Map<String, dynamic> rawData;

  CombatantData({this.rawData = const {}});

  factory CombatantData.fromJson(Map<String, dynamic> json) =>
      _$CombatantDataFromJson(json);

  Map<String, dynamic> toJson() => _$CombatantDataToJson(this);
}
