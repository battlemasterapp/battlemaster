import 'dart:async';

import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/player_view/models/encounter_view.dart';
import 'package:battlemaster/main.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

enum PlayerViewState { disconnected, loading, ready, error }

class PlayerViewNotifier extends ChangeNotifier {
  String? _code;
  final PocketBase _pb;
  PlayerViewState _state = PlayerViewState.loading;
  EncounterView? _encounter;
  AuthProvider auth;
  final _activeIndexController = StreamController<int>.broadcast();

  PlayerViewNotifier({
    required this.auth,
    PocketBase? pb,
  }) : _pb = pb ?? pocketbase;

  PlayerViewState get state => _state;

  EncounterView? get encounter => _encounter;

  Stream<int> get activeIndexStream => _activeIndexController.stream;

  String? get code => _code;

  @override
  void dispose() {
    unsubscribe();
    _activeIndexController.close();
    super.dispose();
  }

  Future<void> subscribe({String? code}) async {
    if (code != null) {
      _code = code;
    }
    assert(_code != null);

    await auth.login(await AnonymousCredentials.generate());
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

    _pb.collection('live_encounters').subscribe(
      encounterRecord.id,
      (data) async {
        if (data.action == 'delete') {
          _state = PlayerViewState.disconnected;
          notifyListeners();
          return;
        }

        final isNewTurn = _encounter?.turn != data.record!.data['turn'];
        _encounter = EncounterView.fromRecord(data.record!.data);
        if (_encounter == null) {
          _state = PlayerViewState.error;
          notifyListeners();
          return;
        }
        if (isNewTurn) {
          _activeIndexController.add(_encounter!.turn);
        }
        _state = PlayerViewState.ready;
        notifyListeners();
      },
    );

    _encounter = EncounterView.fromRecord(encounterRecord.data);
    if (_encounter != null) {
      _activeIndexController.add(_encounter!.turn);
    }
    _state = PlayerViewState.ready;
    notifyListeners();
  }

  Future<void> unsubscribe() async {
    await _pb.collection('live_encounters').unsubscribe();
    _code = null;
    notifyListeners();
  }
}
