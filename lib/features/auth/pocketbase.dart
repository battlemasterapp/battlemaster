import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pocketbase/pocketbase.dart';

final pocketbase = PocketBase(
  const String.fromEnvironment('API_URI'),
  httpClientFactory: kIsWeb ? () => FetchClient(mode: RequestMode.cors) : null,
);
