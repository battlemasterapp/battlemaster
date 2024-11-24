import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';

abstract class ImportCombatantsFactory {
  final GameEngineType engine;
  final String source;

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

  List<Combatant> createCombatants(List<Map<String, dynamic>> data);
}

class CustomCsvCombatantFactory extends ImportCombatantsFactory {
  CustomCsvCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.custom,
        );

  @override
  List<Combatant> createCombatants(List<Map<String, dynamic>> data) {
    data.cast<Map<String, String>>();

    if (data.isEmpty) {
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
    final csvKeys = data.first.keys.toSet();

    if (!requiredKeys.every(csvKeys.contains)) {
      throw Exception('CSV file does not contain all required keys');
    }

    return data
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

class Dnd5eCombatantFactory extends ImportCombatantsFactory {
  Dnd5eCombatantFactory({required super.source})
      : super(
          engine: GameEngineType.dnd5e,
        );

  @override
  List<Combatant> createCombatants(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return [];
    }

    return data.map(
      (entry) {
        return Combatant.from5eCombatantData(
          Dnd5eCombatantData(rawData: entry),
        );
      },
    ).toList();
  }
}
