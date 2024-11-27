import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/player_view/models/encounter_view.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

enum PlayerViewState { disconnected, loading, ready, error }

class PlayerViewNotifier extends ChangeNotifier {
  final String code;
  final PocketBase _pb;
  PlayerViewState _state = PlayerViewState.loading;
  EncounterView? _encounter;
  AuthProvider auth;

  PlayerViewNotifier({
    required this.code,
    required this.auth,
    PocketBase? pb,
  }) : _pb = pb ?? pocketbase;

  PlayerViewState get state => _state;

  EncounterView? get encounter => _encounter;

  Future<void> subscribe() async {
    await auth.login();
    _state = PlayerViewState.loading;
    notifyListeners();

    // Check if the encounter exists
    RecordModel? encounterRecord;

    try {
      encounterRecord = await _pb
          .collection('live_encounters')
          .getFirstListItem('joinCode = "$code"');
    } on ClientException catch (e) {
      if (e.statusCode != 404) {
        _state = PlayerViewState.error;
        notifyListeners();
        rethrow;
      }
    }

    if (encounterRecord == null) {
      _state = PlayerViewState.error;
      notifyListeners();
      return;
    }

    _pb.collection('live_encounters').subscribe(encounterRecord.id,
        (data) async {
      print(data.action);
      if (data.action == 'delete') {
        _state = PlayerViewState.disconnected;
        notifyListeners();
        return;
      }

      _encounter = EncounterView.fromRecord(data.record!.data);
      if (_encounter == null) {
        _state = PlayerViewState.error;
        notifyListeners();
        return;
      }
      _state = PlayerViewState.ready;
      notifyListeners();
    });

    _encounter = EncounterView.fromRecord(encounterRecord.data);
    _state = PlayerViewState.ready;
    notifyListeners();
  }

  Future<void> unsubscribe() async {
    await _pb.collection('live_encounters').unsubscribe();
  }
}
