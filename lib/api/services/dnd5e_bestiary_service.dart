import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:dio/dio.dart';

import '../../features/combatant/models/combatant.dart';
import 'bestiary_service.dart';

class Dnd5eBestiaryService extends BestiaryService {
  Dnd5eBestiaryService()
      : super(
          initialData: [],
          baseUrl: 'https://api.open5e.com',
        ) {
    fetchData();
  }

  final List<String> _defaultSources = [
    "wotc-srd",
  ];

  @override
  String get cacheKey => '5e_bestiary';

  @override
  Future<List<Combatant>?> fetchData({bool forceRefresh = false}) async {
    data.clear();
    final cache = await getCache();

    if (cache != null && !forceRefresh) {
      logger.d('Using cached bestiary data');
      data = await decodeCache(cache) ?? [];
      return data;
    }

    final sources = _defaultSources.join(',');
    // Get the first one just to get the count
    try {
      final getCount = await client
          .get<Map<String, dynamic>>('/v1/monsters/?limit=1&document__slug=$sources');
      final count = getCount.data?['count'] as int;

      logger.d('Found $count 5e bestiary entries for sources: $sources');
      logger.d('Fetching 5e bestiary data');

      final response = await client
          .get<Map<String, dynamic>>('/v1/monsters/?limit=$count&document__slug=$sources');

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
    if (data.isNotEmpty) {
      logger.d('Caching bestiary data');
      await cacheData();
    }
    logger.d('5e bestiary data fetched');
    return data;
  }
}
