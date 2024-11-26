import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class ShareEncounterNotifier extends ChangeNotifier {
  final PocketBase _pb;
  AuthProvider authProvider;
  RecordModel? _sharedEncounter;
  final int _encounterId;

  ShareEncounterNotifier({
    required this.authProvider,
    required int encounterId,
    PocketBase? pb,
  })  : _pb = pb ?? pocketbase,
        _encounterId = encounterId {
    _reconnect();
  }

  bool _live = false;

  bool get live => _live;

  String? get joinCode => _sharedEncounter?.getStringValue('joinCode');

  Future<void> _reconnect() async {
    try {
      _sharedEncounter ??= await _pb
          .collection('live_encounters')
          .getFirstListItem('encounterId = $_encounterId');
    } on ClientException catch (e) {
      if (e.statusCode != 404) {
        rethrow;
      }
    }

    if (_sharedEncounter != null) {
      _live = true;
      notifyListeners();
    }
  }

  Future<void> toggleLive(Encounter encounter) {
    return _live ? _stopLive() : _goLive(encounter);
  }

  Future<void> _goLive(Encounter encounter) async {
    assert(_live == false);
    if (!authProvider.isAuthenticated) {
      await authProvider.anonymousAuth();
    } else {
      await authProvider.refresh();
    }

    RecordModel? sharedEncounter;
    try {
      sharedEncounter = await _pb
          .collection('live_encounters')
          .getFirstListItem('encounterId = ${encounter.id}');
    } on ClientException catch (e) {
      if (e.statusCode != 404) {
        rethrow;
      }
    }

    sharedEncounter ??= await _pb.collection('live_encounters').create(body: {
      'combatants': encounter.combatants.map((c) => c.toJson()).toList(),
      'round': encounter.round,
      'turn': encounter.turn,
      'encounterId': encounter.id,
      authProvider.userKey: authProvider.userModel!.id,
    });

    _sharedEncounter = sharedEncounter;
    _live = true;
    notifyListeners();
  }

  Future<void> _stopLive() async {
    assert(_live == true);
    await _pb.collection('live_encounters').delete(_sharedEncounter!.id);
    _sharedEncounter = null;
    _live = false;
    notifyListeners();
  }

  Future<void> updateEncounter(Encounter encounter) async {
    if (!_live || _sharedEncounter == null) {
      return;
    }

    await _pb.collection('live_encounters').update(_sharedEncounter!.id, body: {
      'combatants': encounter.combatants.map((c) => c.toJson()).toList(),
      'round': encounter.round,
      'turn': encounter.turn,
    });
  }
}
