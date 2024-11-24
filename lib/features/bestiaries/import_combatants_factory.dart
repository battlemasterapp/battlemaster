import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ImportCombatantsResult {
  final List<Combatant> combatants;
  final int failedCount;

  ImportCombatantsResult({
    required this.combatants,
    required this.failedCount,
  });

  factory ImportCombatantsResult.empty() {
    return ImportCombatantsResult(
      combatants: [],
      failedCount: 0,
    );
  }

  bool get isEmpty => combatants.isEmpty;

  bool get isNotEmpty => combatants.isNotEmpty;

  bool get hasFailed => failedCount > 0;
}

abstract class ImportCombatantsFactory {
  final GameEngineType engine;
  final String source;

  @protected
  final logger = Logger();

  ImportCombatantsFactory({
    required this.engine,
    required this.source,
  });

  factory ImportCombatantsFactory.fromEngine(
      GameEngineType engine, String source) {
    switch (engine) {
      case GameEngineType.custom:
        return CustomCsvCombatantFactory(source: source);
      case GameEngineType.dnd5e:
        return Dnd5eCombatantFactory(source: source);
      default:
        throw UnimplementedError('Engine $engine not implemented');
    }
  }

  ImportCombatantsResult createCombatants(List<Map<String, dynamic>> data);
}

class CustomCsvCombatantFactory extends ImportCombatantsFactory {
  CustomCsvCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.custom,
        );

  @override
  ImportCombatantsResult createCombatants(List<Map<String, dynamic>> data) {
    data = data.cast<Map<String, String>>();

    if (data.isEmpty) {
      return ImportCombatantsResult.empty();
    }

    final requiredKeys = <String>{
      'name',
      'hp',
      'armor_class',
      'initiative_mod',
      'level',
      'type'
    };
    final csvKeys = data.first.keys.toSet();

    if (!requiredKeys.every(csvKeys.contains)) {
      throw Exception('CSV file does not contain all required keys');
    }

    int failed = 0;

    final combatants = data.map((entry) {
      try {
        return Combatant(
          name: entry['name']!,
          currentHp: int.parse(entry['hp']!),
          maxHp: int.parse(entry['hp']!),
          initiative: 0,
          armorClass: int.parse(entry['armor_class']!),
          initiativeModifier: int.parse(entry['initiative_mod']!),
          level: double.parse(entry['level']!),
          type: CombatantType.values.byName(entry['type'] ?? ''),
          engineType: GameEngineType.custom,
        );
      } catch (e) {
        logger.e(e);
        failed++;
      }
    }).toList();

    return ImportCombatantsResult(
      combatants: combatants.nonNulls.toList(),
      failedCount: failed,
    );
  }
}

class Dnd5eCombatantFactory extends ImportCombatantsFactory {
  Dnd5eCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.dnd5e,
        );

  @override
  ImportCombatantsResult createCombatants(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return ImportCombatantsResult.empty();
    }

    int failed = 0;

    final combatants = data.map(
      (entry) {
        try {
          return Combatant.from5eCombatantData(
            Dnd5eCombatantData(rawData: entry),
          );
        } catch (e) {
          logger.e(e);
          failed++;
        }
      },
    ).toList();

    return ImportCombatantsResult(
      combatants: combatants.nonNulls.toList(),
      failedCount: failed,
    );
  }
}
