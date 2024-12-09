import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';

class ShareEncounterNotifier extends ChangeNotifier {
  final PocketBase _pb;
  AuthProvider authProvider;
  RecordModel? _sharedEncounter;
  final int _encounterId;
  final _logger = Logger();

  ShareEncounterNotifier({
    required this.authProvider,
    required int encounterId,
    PocketBase? pb,
    bool reconnect = false,
  })  : _pb = pb ?? pocketbase,
        _encounterId = encounterId {
    if (reconnect) {
      _reconnect();
    }
  }

  bool _live = false;

  bool get live => _live;

  String? get joinCode => _sharedEncounter?.getStringValue('joinCode');

  Future<void> _reconnect() async {
    _logger.d('Reconnecting to live encounter');
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

    if (_sharedEncounter == null) {
      _logger.d('Encounter is not live');
      return;
    }

    _logger.d('Reconnected to live encounter');
    _live = true;
    notifyListeners();
  }

  Future<String?> toggleLive(
    Encounter encounter, {
    Map<String, bool>? flags,
  }) {
    return _live ? stopLive() : goLive(encounter, flags: flags);
  }

  Future<String?> goLive(
    Encounter encounter, {
    Map<String, bool>? flags,
  }) async {
    _logger.d('Going live with encounter');
    assert(_live == false);
    await authProvider.login();

    RecordModel? sharedEncounter;
    try {
      sharedEncounter = await _pb.collection('live_encounters').getFirstListItem(
          'encounterId = $_encounterId && ${authProvider.userKey} = "${authProvider.userModel!.id}"');
      _logger.d('Found existing live encounter');
    } on ClientException catch (e) {
      if (e.statusCode != 404) {
        rethrow;
      }
      _logger.d('No existing live encounter found');
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
    _logger.d('Encounter is now live');
    return joinCode;
  }

  Future<String?> stopLive() async {
    assert(_live == true);
    _logger.d('Stopping live encounter');
    await _pb.collection('live_encounters').delete(_sharedEncounter!.id);
    _sharedEncounter = null;
    _live = false;
    notifyListeners();
    _logger.d('Encounter is no longer live');
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
