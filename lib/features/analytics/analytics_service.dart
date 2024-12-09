import 'package:battlemaster/features/analytics/plausible.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AnalyticsService {
  PackageInfo? _packageInfo;

  final Logger _logger = Logger();

  AnalyticsService() {
    init();
  }

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _logger.d('Initializing analytics');
  }

  Future<void> logEvent(
    String name, {
    String page = "",
    Map<String, String>? props,
  }) async {
    _logger.d('Logging event: $name');
    await plausible.send(
      event: name,
      path: page,
      props: {
        ..._getAppProps(),
        ...?props,
      },
    );
  }

  Map<String, String> _getAppProps() {
    final props = <String, String?>{
      'app_version': _packageInfo?.version,
      'app_name': _packageInfo?.appName,
      'app_package': _packageInfo?.packageName,
      'platform': defaultTargetPlatform.toString(),
    };
    props.removeWhere((key, value) => value == null);
    return props.cast<String, String>();
  }
}