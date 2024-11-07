import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/foundation.dart';

abstract class CombatantData {
  final Map<String, dynamic> rawData;

  @protected
  final GameEngineType engine;

  CombatantData({
    required this.engine,
    this.rawData = const {},
  });

  Map<String, dynamic> toJson();
}
