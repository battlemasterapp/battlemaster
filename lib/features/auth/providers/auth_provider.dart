import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:fingerprint/fingerprint.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthProvider extends ChangeNotifier {
  final PocketBase _pb;
  bool _anonymousLogin = false;

  AuthProvider({
    PocketBase? pb,
  }) : _pb = pb ?? pocketbase;

  RecordModel? get userModel => _pb.authStore.record;

  bool get isAuthenticated => _pb.authStore.isValid;

  bool get isAnonymous => _anonymousLogin;

  String get userKey => _anonymousLogin ? 'anonymousId' : 'userId';

  String get _userCollection => _anonymousLogin ? 'anonymous_users' : 'users';

  Future<bool> auth() async {
    throw UnimplementedError();
  }

  Future<bool> anonymousAuth() async {
    // TODO: save fingerprint to local storage/secure storage
    final fingerprint = await Fingerprint.create();

    await _pb.send(
      '/api/anonymous-user',
      method: 'POST',
      headers: {'X-FINGERPRINT': fingerprint.toString()},
    );
    await _pb.collection('anonymous_users').authWithPassword(
          fingerprint.toString(),
          fingerprint.toString(),
        );

    _anonymousLogin = true;
    notifyListeners();
    return true;
  }

  Future<void> refresh() async {
    await _pb.collection(_userCollection).authRefresh();
    notifyListeners();
  }

  void logout() {
    _pb.authStore.clear();
    notifyListeners();
  }
}
