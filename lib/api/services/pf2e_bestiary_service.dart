import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/combatant/models/combatant.dart';
import '../../features/combatant/models/pf2e_combatant_data.dart';
import 'pf2e_data_service.dart';

class Pf2eBestiaryService extends Pf2eDataService<List<Combatant>> {
  Pf2eBestiaryService() : super(initialData: []) {
    fetchData();
  }

  List<Combatant> get bestiaryData => data;

  final List<String> _defaultSources = [
    "book-of-the-dead",
    "npc-gallery",
    "pathfinder-bestiary-2",
    "pathfinder-bestiary-3",
    "pathfinder-dark-archive",
    "pathfinder-monster-core",
    "pathfinder",
    "rage-of-elements",
  ];

  final Map<String, String> _availableSources = {};

  @override
  String get cacheKey => 'pf2e_bestiary';

  @override
  Future<List<Combatant>?> decodeCache(String cache) async {
    return await Isolate.run(() async {
      final cachedList =
          (jsonDecode(cache) as List).cast<Map<String, dynamic>>();
      return cachedList.map((e) => Combatant.fromJson(e)).toList();
    });
  }

  @override
  Future<String> encodeCache(List<Combatant> data) async {
    return await Isolate.run(() async {
      return jsonEncode(data.map((e) => e.toJson()).toList());
    });
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
  Future<List<Combatant>?> fetchData({bool forceRefresh = false}) async {
    data.clear();
    final prefs = await SharedPreferences.getInstance();
    final cache = prefs.getString(cacheKey);

    if (cache != null && !forceRefresh) {
      logger.d('Using cached bestiary data');
      data = await decodeCache(cache) ?? [];
      return data;
    }

    await _getAvailableSources();
    for (final source in _defaultSources) {
      logger.d('Fetching bestiary data for $source');
      final sourceUri = _availableSources[source];
      if (sourceUri == null) {
        logger.e('Source $source not found');
        continue;
      }
      try {
        final bestiaryResponse = await client.get("/bestiaries/$sourceUri");
        final bestiaryData = (jsonDecode(bestiaryResponse.data) as List)
            .cast<Map<String, dynamic>>();
        data.addAll(bestiaryData
            .map(
              (data) => Combatant.fromPf2eCombatantData(
                Pf2eCombatantData(
                  rawData: data,
                ),
              ),
            )
            .toList());
      } on DioException catch (e) {
        logger.e(e);
      }
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    await cacheData();
    logger.d('Fetched pf2e bestiary entries');
    return data;
  }
}
