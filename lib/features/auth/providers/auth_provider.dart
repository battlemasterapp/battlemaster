import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:fingerprint/fingerprint.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthProvider extends ChangeNotifier {
  final PocketBase _pb;
  bool _anonymousLogin = true;
  Fingerprint? _fingerprint;

  AuthProvider({
    PocketBase? pb,
  }) : _pb = pb ?? pocketbase;

  RecordModel? get userModel => _pb.authStore.record;

  bool get isAuthenticated => _pb.authStore.isValid;

  bool get isAnonymous => _anonymousLogin;

  String get userKey => _anonymousLogin ? 'anonymousId' : 'userId';

  String get _userCollection => _anonymousLogin ? 'anonymous_users' : 'users';

  Future<bool> login() async {
    if (isAuthenticated) {
      await refresh();
      return true;
    }

    if (isAnonymous) {
      await _anonymousAuth();
      return true;
    }

    await _auth();
    return true;
  }

  Future<bool> _auth() async {
    throw UnimplementedError();
  }

  Future<bool> _anonymousAuth() async {
    _fingerprint ??= await Fingerprint.create();

    await _pb.send(
      '/api/anonymous-user',
      method: 'POST',
      headers: {'X-FINGERPRINT': _fingerprint.toString()},
    );
    await _pb.collection('anonymous_users').authWithPassword(
          _fingerprint.toString(),
          _fingerprint.toString(),
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
