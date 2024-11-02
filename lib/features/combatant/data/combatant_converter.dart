import 'dart:convert';

import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:drift/drift.dart';

class CombatantsConverter extends TypeConverter<List<Combatant>, String>
    with JsonTypeConverter<List<Combatant>, String> {
  const CombatantsConverter();

  @override
  List<Combatant> fromSql(String fromDb) {
    final combatants = jsonDecode(fromDb) as List;
    return combatants.cast<Map<String, dynamic>>().map((e) => Combatant.fromJson(e)).toList();
  }

  @override
  String toSql(List<Combatant> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
