import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';

abstract class CsvCombatantFactory {
  final GameEngineType engine;
  final String source;

  CsvCombatantFactory({
    required this.engine,
    required this.source,
  });

  factory CsvCombatantFactory.fromEngine(GameEngineType engine, String source) {
    switch (engine) {
      case GameEngineType.custom:
        return CustomCsvCombatantFactory(source: source);
      case GameEngineType.dnd5e:
        return Dnd5eCsvCombatantFactory(source: source);
      default:
        throw UnimplementedError('Engine $engine not implemented');
    }
  }

  List<Combatant> createCombatants(List<Map<String, String>> csvData);
}

class CustomCsvCombatantFactory extends CsvCombatantFactory {
  CustomCsvCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.custom,
        );

  @override
  List<Combatant> createCombatants(List<Map<String, String>> csvData) {
    if (csvData.isEmpty) {
      return [];
    }

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

class Dnd5eCsvCombatantFactory extends CsvCombatantFactory {
  // FIXME: we should use a JSON file instead of a CSV file for complex combatants
  Dnd5eCsvCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.dnd5e,
        );

  @override
  List<Combatant> createCombatants(List<Map<String, String>> csvData) {
    if (csvData.isEmpty) {
      return [];
    }

    final requiredKeys = <String>{
      'name',
      'hit_points',
      'armor_class',
      'challenge_rating',
    };

    final csvKeys = csvData.first.keys.toSet();

    if (!requiredKeys.every(csvKeys.contains)) {
      throw Exception('CSV file does not contain all required keys');
    }

    return csvData.map(
      (entry) {
        final rawData = {
          ...entry,
          'document__title': source,
          'hit_points': int.tryParse(entry['hit_points']!),
          'armor_class': int.tryParse(entry['armor_class']!),
          'cr': double.tryParse(entry['challenge_rating']!),
          'level': double.tryParse(entry['challenge_rating']!),
          'strength': int.tryParse(entry['strength'] ?? '0'),
          'strength_save': int.tryParse(entry['strength_save'] ?? ''),
          'dexterity': int.tryParse(entry['dexterity'] ?? '0'),
          'dexterity_save': int.tryParse(entry['dexterity_save'] ?? ''),
          'constitution': int.tryParse(entry['constitution'] ?? '0'),
          'constitution_save': int.tryParse(entry['constitution_save'] ?? ''),
          'intelligence': int.tryParse(entry['intelligence'] ?? '0'),
          'intelligence_save': int.tryParse(entry['intelligence_save'] ?? ''),
          'wisdom': int.tryParse(entry['wisdom'] ?? '0'),
          'wisdom_save': int.tryParse(entry['wisdom_save'] ?? ''),
          'charisma': int.tryParse(entry['charisma'] ?? '0'),
          'charisma_save': int.tryParse(entry['charisma_save'] ?? ''),
          'speed': {
            'walk': int.tryParse(entry['speed_walk'] ?? '0'),
            'fly': int.tryParse(entry['speed_fly'] ?? '0'),
            'swim': int.tryParse(entry['speed_swim'] ?? '0'),
            'climb': int.tryParse(entry['speed_climb'] ?? '0'),
            'burrow': int.tryParse(entry['speed_burrow'] ?? '0'),
          },
        };
        return Combatant.from5eCombatantData(
          Dnd5eCombatantData(rawData: rawData),
        );
      },
    ).toList();
  }
}
