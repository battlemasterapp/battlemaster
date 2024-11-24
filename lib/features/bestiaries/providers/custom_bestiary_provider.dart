import 'dart:convert';

import 'package:battlemaster/database/database.dart' as db;
import 'package:battlemaster/features/bestiaries/import_combatants_factory.dart';
import 'package:battlemaster/features/bestiaries/models/custom_bestiary.dart';
import 'package:battlemaster/features/settings/models/custom_bestiary_file.dart';
import 'package:csv2json/csv2json.dart';
import 'package:flutter/foundation.dart';

Future<List<Map<String, dynamic>>> _decodeFile(
    CustomBestiaryFile bestiaryFile) async {
  final file = bestiaryFile.file;
  late String fileContent;

  if (file != null) {
    fileContent = await file.readAsString();
  } else {
    fileContent = String.fromCharCodes(bestiaryFile.bytes!);
  }

  final data = bestiaryFile.extension == 'csv'
      ? csv2json(fileContent)
      : jsonDecode(fileContent) as List;
  return data.cast<Map<String, dynamic>>();
}

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
    final data = await compute(_decodeFile, bestiaryFile);

    if (data.isEmpty) {
      throw Exception('No data found in the file');
    }

    final combatants = ImportCombatantsFactory.fromEngine(
      bestiaryFile.engine,
      bestiaryFile.name,
    ).createCombatants(data);

    if (combatants.isEmpty) {
      throw Exception('No combatants found in the file');
    }

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

  Future<void> delete(CustomBestiary bestiary) async {
    await _database.deleteBestiary(bestiary.id);
    notifyListeners();
  }
}
