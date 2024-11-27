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
    // FIXME: only autoreconnect if feature is enabled
    _reconnect();
  }

  bool _live = false;

  bool get live => _live;

  String? get joinCode => _sharedEncounter?.getStringValue('joinCode');

  Future<void> _reconnect() async {
    if (!authProvider.isAuthenticated) {
      await authProvider.login();
    }
    try {
      _sharedEncounter ??= await _pb.collection('live_encounters').getFirstListItem(
          'encounterId = $_encounterId && ${authProvider.userKey} = "${authProvider.userModel?.id}"');
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

  Future<String?> toggleLive(
    Encounter encounter, {
    Map<String, bool>? flags,
  }) {
    return _live ? _stopLive() : _goLive(encounter, flags: flags);
  }

  Future<String?> _goLive(
    Encounter encounter, {
    Map<String, bool>? flags,
  }) async {
    assert(_live == false);
    await authProvider.login();

    RecordModel? sharedEncounter;
    try {
      sharedEncounter = await _pb.collection('live_encounters').getFirstListItem(
          'encounterId = $_encounterId && ${authProvider.userKey} = "${authProvider.userModel!.id}"');
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
      'flags': flags,
      authProvider.userKey: authProvider.userModel!.id,
    });

    _sharedEncounter = sharedEncounter;
    _live = true;
    notifyListeners();
    return joinCode;
  }

  Future<String?> _stopLive() async {
    assert(_live == true);
    await _pb.collection('live_encounters').delete(_sharedEncounter!.id);
    _sharedEncounter = null;
    _live = false;
    notifyListeners();
    return null;
  }

  Future<void> updateEncounter(Encounter encounter) async {
    if (!_live || _sharedEncounter == null) {
      return;
    }

    await _pb.collection('live_encounters').update(_sharedEncounter!.id, body: {
      'combatants': encounter.combatants.map((c) => c.toShortJson()).toList(),
      'round': encounter.round,
      'turn': encounter.turn,
    });
  }
}
