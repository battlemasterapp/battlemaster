import 'dart:convert';

import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/combatant/models/combatant.dart';
import 'data_service.dart';

class Dnd5eBestiaryService extends DataService<List<Combatant>> {
  Dnd5eBestiaryService()
      : super(
          initialData: [],
          baseUrl: 'https://api.open5e.com/monsters',
        ) {
    fetchData();
  }

  final List<String> _defaultSources = [
    "wotc-srd",
  ];

  List<Combatant> get bestiaryData => data;

  @override
  String get cacheKey => '5e_bestiary';

  @override
  List<Combatant>? decodeCache(String cache) {
    final cachedList = (jsonDecode(cache) as List).cast<Map<String, dynamic>>();
    return cachedList.map((e) => Combatant.fromJson(e)).toList();
  }

  @override
  String encodeCache(List<Combatant> data) {
    return jsonEncode(data.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<Combatant>?> fetchData({bool forceRefresh = true}) async {
    data.clear();
    final prefs = await SharedPreferences.getInstance();
    final cache = prefs.getString(cacheKey);

    if (cache != null && !forceRefresh) {
      logger.d('Using cached bestiary data');
      data = decodeCache(cache) ?? [];
      return data;
    }

    final sources = _defaultSources.join(',');
    // Get the first one just to get the count
    try {
      final getCount = await client
          .get<Map<String, dynamic>>('?limit=1&document__slug=$sources');
      final count = getCount.data?['count'] as int;

      logger.d('Found $count 5e bestiary entries for sources: $sources');
      logger.d('Fetching 5e bestiary data');

      final response = await client
          .get<Map<String, dynamic>>('?limit=$count&document__slug=$sources');

      final results = (response.data?['results'] as List? ?? [])
          .cast<Map<String, dynamic>>();
      data.addAll(results
          .map<Combatant>((entry) =>
              Combatant.from5eCombatantData(Dnd5eCombatantData(rawData: entry)))
          .toList());
    } on DioException catch (e) {
      logger.e(e);
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    await cacheData();
    logger.d('5e bestiary data fetched and cached');
    return data;
  }
}
