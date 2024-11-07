import 'package:battlemaster/features/engines/models/game_engine_type.dart';

abstract class CombatantData {
  final Map<String, dynamic> rawData;

  final GameEngineType engine;

  CombatantData({
    required this.engine,
    this.rawData = const {},
  });

  Map<String, dynamic> toJson();
}
