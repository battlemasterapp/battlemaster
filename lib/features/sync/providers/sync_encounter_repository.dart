import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/main.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SyncEncounterRepository {
  final AuthProvider _auth;
  final PocketBase _pb;
  final String _tableName = "encounters";
  final Logger logger = Logger();

  SyncEncounterRepository({
    required AuthProvider auth,
    PocketBase? pb,
  })  : _auth = auth,
        _pb = pb ?? pocketbase;

  bool _canSync() {
    return _auth.isAuthenticated && !_auth.isAnonymous;
  }

  Future<void> upsertEncounter(Encounter encounter) async {
    if (!_canSync()) {
      return;
    }

    RecordModel? record;

    try {
      // check if exists
      record = await _pb.collection(_tableName).getFirstListItem(
            'userId = "${_auth.userModel?.id}" && encounterId = ${encounter.id}',
          );

      // if exists update
      await _pb.collection(_tableName).update(
        record.id,
        body: {
          "data": encounter.toJson(),
        },
      );
    } catch (e) {
      logger.e(e);
      // create new record
      await _pb.collection(_tableName).create(
        body: {
          "userId": _auth.userModel?.id,
          "data": encounter.toJson(),
          "encounterId": encounter.id,
        },
      );
    }
  }

  Future<void> deleteEncounter(Encounter encounter) async {
    if (!_canSync()) {
      return;
    }

    try {
      final record = await _pb.collection(_tableName).getFirstListItem(
            'userId = "${_auth.userModel?.id}" && encounterId = ${encounter.id}',
          );
      await _pb.collection(_tableName).delete(record.id);
    } catch (e) {
      Sentry.captureException(e);
      logger.e(e);
    }
  }

  Future<List<Encounter>> getEncounters() async {
    if (!_canSync()) {
      return [];
    }

    final result = await _pb.collection(_tableName).getFullList();
    return result
        .map((entry) => Encounter.fromJson(entry.data["data"]))
        .toList();
  }
}
