import 'dart:io';

import 'package:battlemaster/features/auth/pocketbase.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fingerprint/fingerprint.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthProvider extends ChangeNotifier {
  final PocketBase _pb;
  bool _anonymousLogin = true;
  Fingerprint? _fingerprint;
  BaseDeviceInfo? _deviceInfo;

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

  String _getPlatform() {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    if (Platform.isMacOS) {
      return 'macos';
    }
    if (Platform.isWindows) {
      return 'windows';
    }
    if (Platform.isLinux) {
      return 'linux';
    }
    return 'unknown';
  }

  String _getEnv() {
    if (kProfileMode) {
      return 'profile';
    }
    if (kReleaseMode) {
      return 'release';
    }
    return 'debug';
  }

  Future<String> _getDevice() async {
    _deviceInfo ??= await DeviceInfoPlugin().deviceInfo;
    if (_deviceInfo is AndroidDeviceInfo) {
      return (_deviceInfo as AndroidDeviceInfo).model;
    }
    if (_deviceInfo is IosDeviceInfo) {
      return (_deviceInfo as IosDeviceInfo).utsname.machine;
    }
    if (_deviceInfo is LinuxDeviceInfo) {
      return (_deviceInfo as LinuxDeviceInfo).prettyName;
    }
    if (_deviceInfo is MacOsDeviceInfo) {
      return (_deviceInfo as MacOsDeviceInfo).model;
    }
    if (_deviceInfo is WindowsDeviceInfo) {
      return (_deviceInfo as WindowsDeviceInfo).computerName;
    }
    if (_deviceInfo is WebBrowserInfo) {
      return (_deviceInfo as WebBrowserInfo).userAgent ?? 'web';
    }

    return 'unknown';
  }

  Future<bool> _anonymousAuth() async {
    _fingerprint ??= await Fingerprint.create();

    await _pb.send(
      '/api/anonymous-user',
      method: 'POST',
      body: {
        'platform': _getPlatform(),
        'env': _getEnv(),
        'device': await _getDevice(),
      },
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
