import 'dart:io';

import 'package:battlemaster/features/sync/widgets/signup_form.dart';
import 'package:battlemaster/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fingerprint/fingerprint.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthCredentials {
  final String email;
  final String password;

  AuthCredentials(this.email, this.password);
}

class AnonymousCredentials extends AuthCredentials {
  AnonymousCredentials(super.email, super.password);

  static Future<AnonymousCredentials> generate() async {
    final fingerprint = await Fingerprint.create();
    final fingerprintString = fingerprint.toString();

    return AnonymousCredentials(fingerprintString, fingerprintString);
  }
}

class UserCredentials extends AuthCredentials {
  UserCredentials(super.email, super.password);
}

class AuthProvider extends ChangeNotifier {
  final PocketBase _pb;
  BaseDeviceInfo? _deviceInfo;

  AuthProvider({
    PocketBase? pb,
  }) : _pb = pb ?? pocketbase;

  RecordModel? get userModel => _pb.authStore.record;

  bool get isAuthenticated => _pb.authStore.isValid;

  bool get isAnonymous => _pb.authStore.record?.collectionName == 'anonymous_users';

  String get userKey => isAnonymous ? 'anonymousId' : 'userId';

  String get _userCollection => isAnonymous ? 'anonymous_users' : 'users';

  Future<bool> login(AuthCredentials credentials) async {
    if (isAuthenticated) {
      await refresh();
      return true;
    }

    if (credentials is AnonymousCredentials) {
      await _anonymousAuth(credentials);
      return true;
    }

    if (credentials is UserCredentials) {
      await _auth(credentials);
      return true;
    }

    throw UnimplementedError();
  }

  Future<bool> _auth(UserCredentials credentials) async {
    await _pb.collection("users").authWithPassword(
          credentials.email,
          credentials.password,
        );
    notifyListeners();
    return true;
  }

  Future<bool> signUp(SignupData data) async {
    try {
      await _pb.collection("users").create(
        body: {
          "email": data.email,
          "name": data.name,
          "password": data.password,
          "passwordConfirm": data.passwordConfirmation,
        },
      );
    } catch (e) {
      await Sentry.captureException(e);
      return false;
    }
    return true;
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

  Future<bool> _anonymousAuth(AnonymousCredentials credentials) async {
    await _pb.send(
      '/api/anonymous-user',
      method: 'POST',
      body: {
        'platform': _getPlatform(),
        'env': _getEnv(),
        'device': await _getDevice(),
      },
      headers: {'X-FINGERPRINT': credentials.email},
    );
    await _pb.collection('anonymous_users').authWithPassword(
          credentials.email,
          credentials.password,
        );

    notifyListeners();
    return true;
  }

  Future<void> refresh() async {
    await _pb.collection(_userCollection).authRefresh();
    notifyListeners();
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("pb_auth");
  }
}
