import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@JsonSerializable()
class Condition extends Equatable {
  final String name;
  final String description;
  final GameEngineType engine;
  final int? durationRounds;
  final int? value;

  const Condition({
    required this.name,
    required this.description,
    required this.engine,
    this.durationRounds,
    this.value,
  });

  factory Condition.fromCustomCondition(CustomCondition entry) => Condition(
        name: entry.name,
        description: entry.description,
        engine: entry.engine,
      );

  factory Condition.from5e(Map<String, dynamic> entry) => Condition(
        name: entry['name'] as String,
        description: entry['desc'] as String,
        engine: GameEngineType.dnd5e,
      );

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionToJson(this);

  Condition copyWith({
    String? name,
    String? description,
    GameEngineType? engine,
    int? durationRounds,
    int? value,
  }) {
    return Condition(
      name: name ?? this.name,
      description: description ?? this.description,
      engine: engine ?? this.engine,
      durationRounds: durationRounds ?? this.durationRounds,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        durationRounds,
        value,
      ];
}
