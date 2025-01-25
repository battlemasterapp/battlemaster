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

  Future<String?> upsertEncounter(Encounter encounter) async {
    if (!_canSync()) {
      return null;
    }

    if (encounter.syncId != null) {
      await _pb.collection(_tableName).update(
        encounter.syncId!,
        body: {
          "data": encounter.toJson(),
        },
      );
      return encounter.syncId;
    }

    final record = await _pb.collection(_tableName).create(
      body: {
        "userId": _auth.userModel?.id,
        "data": encounter.toJson(),
      },
    );
    return record.id;
  }

  Future<void> deleteEncounter(Encounter encounter) async {
    if (!_canSync()) {
      return;
    }

    if (encounter.syncId == null) {
      return;
    }

    try {
      await _pb.collection(_tableName).delete(encounter.syncId!);
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
        .map((entry) =>
            Encounter.fromJson(entry.data["data"]..["syncId"] = entry.id))
        .toList();
  }
}
