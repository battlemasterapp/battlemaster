import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pf2e_data_service.dart';

class Pf2eBestiaryService extends Pf2eDataService<List<Map>> {
  Pf2eBestiaryService() : super(initialData: []) {
    init().then((_) => fetchData());
  }

  List<Map> get bestiaryData => data;

  final List<String> _defaultSources = [
    'pathfinder-monster-core',
  ];

  final Map<String, String> _availableSources = {};

  @override
  String get cacheKey => 'pf2e_bestiary';

  @override
  List<Map>? decodeCache(String cache) {
    return (jsonDecode(cache) as List).cast<Map>();
  }

  @override
  String encodeCache(List<Map> data) {
    return jsonEncode(data);
  }

  Future<void> init() async {
    logger.d('Initializing bestiary service');
    await _getAvailableSources();
  }

  Future<Map<String, String>> _getAvailableSources() async {
    logger.d('Fetching available bestiary sources');
    final response = await client.get('/bestiaries/index.json');

    final Map<String, String> allSources =
        (jsonDecode(response.data) as Map? ?? {}).cast<String, String>();

    _availableSources.addAll(allSources);

    return allSources;
  }

  @override
  Future<List<Map>?> fetchData({bool forceRefresh = false}) async {
    data.clear();
    final prefs = await SharedPreferences.getInstance();
    final cache = prefs.getString(cacheKey);

    if (cache != null && !forceRefresh) {
      logger.d('Using cached bestiary data');
      data = decodeCache(cache)!;
    } else {
      for (final source in _defaultSources) {
        logger.d('Fetching bestiary data for $source');
        final sourceUri = _availableSources[source];
        if (sourceUri == null) {
          logger.e('Source $source not found');
          continue;
        }
        try {
          final bestiaryResponse = await client.get("/bestiaries/$sourceUri");
          final bestiaryData =
              (jsonDecode(bestiaryResponse.data) as List).cast<Map>();
          data.addAll(bestiaryData);
        } on DioException catch (e) {
          logger.e(e);
        }
      }
    }

    return data;
  }
}
