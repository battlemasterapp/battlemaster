import 'combatant_data.dart';

class Pf2eCombatantData extends CombatantData {
  Pf2eCombatantData({super.rawData});

  String get name => rawData['name'] ?? "";

  int get hp => rawData['system']?['attributes']?['hp']?['max'] ?? 0;

  int get ac => rawData['system']?['attributes']?['ac']?['value'] ?? 0;

  int get initiativeModifier => rawData['system']?['perception']?['mod'] ?? 0;

  int get level => rawData['system']?['details']?['level']?['value'] ?? 0;

  String get source =>
      rawData['system']?['details']?['publication']?['title'] ?? '';

  List<String> get traits {
    final rarity = rawData['system']?['traits']?['rarity'];
    String? size = rawData['system']?['traits']?['size']?['value'];

    final sizeMap = {
      'med': 'medium',
      'sm': 'small',
      'grg': 'gargantuan',
      'lg': 'large',
    };

    return <String?>[
      if (rarity != "common") rarity,
      sizeMap[size] ?? size,
      ...rawData['system']['traits']['value'].cast<String>(),
    ].nonNulls.toList();
  }
}
