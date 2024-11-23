import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';

abstract class CsvCombatantFactory {
  final GameEngineType engine;

  CsvCombatantFactory(this.engine);

  factory CsvCombatantFactory.fromEngine(GameEngineType engine) {
    switch (engine) {
      case GameEngineType.custom:
        return CustomCsvCombatantFactory(engine);
      default:
        throw UnimplementedError('Engine $engine not implemented');
    }
  }

  List<Combatant> createCombatants(List<Map<String, String>> csvData);
}

class CustomCsvCombatantFactory extends CsvCombatantFactory {
  CustomCsvCombatantFactory(super.engine);

  @override
  List<Combatant> createCombatants(List<Map<String, String>> csvData) {
    final requiredKeys = <String>{
      'name',
      'hp',
      'armor_class',
      'initiative_mod',
      'level',
      'type'
    };
    final csvKeys = csvData.first.keys.toSet();

    if (!requiredKeys.every(csvKeys.contains)) {
      throw Exception('CSV file does not contain all required keys');
    }

    return csvData
        .map((entry) => Combatant(
              name: entry['name']!,
              currentHp: int.parse(entry['hp']!),
              maxHp: int.parse(entry['hp']!),
              initiative: 0,
              armorClass: int.parse(entry['armor_class']!),
              initiativeModifier: int.parse(entry['initiative_mod']!),
              level: double.parse(entry['level']!),
              type: CombatantType.values.byName(entry['type'] ?? ''),
              engineType: GameEngineType.custom,
            ))
        .toList();
  }
}
