import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/foundation.dart';

class ConditionsProvider extends ChangeNotifier {
  final AppDatabase _database;

  ConditionsProvider(AppDatabase database) : _database = database;

  Stream<List<CustomCondition>> watchConditions() =>
      _database.watchConditions();

  Future<List<CustomCondition>> getConditions() => _database.getConditions();

  Future<Condition> addCondition(CustomCondition condition) async {
    final created = await _database.insertCondition(condition);
    return Condition.fromCustomCondition(created);
  }

  Future<void> deleteCondition(CustomCondition condition) async {
    await _database.deleteCondition(condition);
  }
}
