import 'package:battlemaster/features/analytics/plausible_base.dart';
import 'package:flutter/widgets.dart';

/// A [NavigatorObserver] that reports page views to [Plausible].
class AnalyticsNavigatorObserver extends NavigatorObserver {
  /// The [Plausible] instance to report page views to.
  final Plausible plausible;

  /// Creates a [AnalyticsNavigatorObserver].
  AnalyticsNavigatorObserver(this.plausible);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    plausible.send(path: route.settings.name ?? '');
  }
}
