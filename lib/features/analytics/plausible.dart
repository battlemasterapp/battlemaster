import 'package:plausible/plausible.dart';

const _server = String.fromEnvironment("PLAUSIBLE_SERVER");
const _domain = String.fromEnvironment("PLAUSIBLE_DOMAIN");

final plausible = Plausible(
  server: Uri.parse(_server),
  domain: _domain,
);