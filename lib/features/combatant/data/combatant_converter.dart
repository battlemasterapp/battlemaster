import 'dart:convert';

import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:drift/drift.dart';

class CombatantConverter extends TypeConverter<Combatant, String>
    with JsonTypeConverter<Combatant, String> {
  const CombatantConverter();

  @override
  Combatant fromSql(String fromDb) {
    return Combatant.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(Combatant value) {
    return jsonEncode(value.toJson());
  }
}
