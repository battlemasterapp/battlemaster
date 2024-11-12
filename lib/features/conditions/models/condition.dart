import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@JsonSerializable()
class Condition extends Equatable {
  final String name;
  final String description;
  final int? durationRounds;
  final int? value;

  const Condition({
    required this.name,
    required this.description,
    this.durationRounds,
    this.value,
  });

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionToJson(this);

  Condition copyWith({
    String? name,
    String? description,
    int? durationRounds,
    int? value,
  }) {
    return Condition(
      name: name ?? this.name,
      description: description ?? this.description,
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