import 'package:battlemaster/database/database.dart' as db;
import 'package:battlemaster/features/bestiaries/csv_combatant_factory.dart';
import 'package:battlemaster/features/bestiaries/models/custom_bestiary.dart';
import 'package:battlemaster/features/settings/models/custom_bestiary_file.dart';
import 'package:csv2json/csv2json.dart';
import 'package:flutter/material.dart';

class CustomBestiaryProvider extends ChangeNotifier {
  final db.AppDatabase _database;

  CustomBestiaryProvider(db.AppDatabase database) : _database = database;

  Stream<List<CustomBestiary>> watchAll() =>
      _database.watchCustomBestiaries().asyncMap((rows) => rows
          .map((row) => CustomBestiary(
                id: row.id,
                name: row.name,
                combatants: row.combatants,
                engine: row.engine,
              ))
          .toList());

  Future<void> create(CustomBestiaryFile bestiaryFile) async {
    final file = bestiaryFile.file;
    final csvData = await file.readAsString();
    final data = csv2json(csvData);

    final combatants = CsvCombatantFactory.fromEngine(bestiaryFile.engine)
        .createCombatants(data);

    await _database.insertBestiary(
      db.CustomBestiary(
        id: -1,
        name: bestiaryFile.name,
        combatants: combatants,
        engine: bestiaryFile.engine,
      ),
    );
    notifyListeners();
  }
}
