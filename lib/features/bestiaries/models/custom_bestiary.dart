import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_bestiary.g.dart';

@JsonSerializable()
class CustomBestiary {
  final int id;
  final String name;
  final String combatants;
  final GameEngineType engine;

  const CustomBestiary({
    required this.id,
    required this.name,
    required this.combatants,
    required this.engine,
  });

  factory CustomBestiary.fromJson(Map<String, dynamic> json) =>
      _$CustomBestiaryFromJson(json);

  Map<String, dynamic> toJson() => _$CustomBestiaryToJson(this);
}