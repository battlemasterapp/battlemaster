import 'dart:convert';

import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:drift/drift.dart';

class EncounterLogConverter extends TypeConverter<List<EncounterLog>, String>
    with JsonTypeConverter<List<EncounterLog>, String> {
  const EncounterLogConverter();

  @override
  List<EncounterLog> fromSql(String fromDb) {
    final logs = jsonDecode(fromDb) as List;
    return logs
        .cast<Map<String, dynamic>>()
        .map((e) => EncounterLog.fromJson(e))
        .toList();
  }

  @override
  String toSql(List<EncounterLog> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
