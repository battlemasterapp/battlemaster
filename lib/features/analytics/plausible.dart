import 'package:plausible_analytics/plausible_analytics.dart';

const _server = String.fromEnvironment("PLAUSIBLE_SERVER");
const _domain = String.fromEnvironment("PLAUSIBLE_DOMAIN");

final plausible = Plausible(_server, _domain);
