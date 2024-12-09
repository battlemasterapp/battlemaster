import 'dart:convert';

import 'package:battlemaster/api/services/data_service.dart';
import 'package:flutter/foundation.dart';

import '../../features/combatant/models/combatant.dart';

String _encodeCombatants(List<Combatant> data) {
  return jsonEncode(data.map((e) => e.toJson()).toList());
}

List<Combatant> _decodeCombatant(String cache) {
  final list = (jsonDecode(cache) as List).cast<Map<String, dynamic>>();
  return list.map((e) => Combatant.fromJson(e)).toList();
}

abstract class BestiaryService extends DataService<List<Combatant>> {
  BestiaryService({required super.initialData, required super.baseUrl});

  List<Combatant> get bestiaryData => data;

  @override
  Future<List<Combatant>?> decodeCache(String cache) async {
    return await compute(
      _decodeCombatant,
      cache,
    );
  }

  @override
  Future<String> encodeCache(List<Combatant> data) async {
    return await compute(
      _encodeCombatants,
      data,
    );
  }
}
