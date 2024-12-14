import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../features/combatant/models/combatant.dart';
import '../../features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'bestiary_service.dart';

const _baseUrl = String.fromEnvironment("PF2E_URI");

List<Map<String, dynamic>> _decodeBestiaryResponse(String response) {
  return (jsonDecode(response) as List).cast<Map<String, dynamic>>();
}

class Pf2eBestiaryService extends BestiaryService {
  final Set<String> bestiarySources;

  Pf2eBestiaryService({
    this.bestiarySources = const {},
  }) : super(
          initialData: [],
          baseUrl: _baseUrl,
        );

  final Map<String, String> _availableSources = {};

  @override
  String get cacheKey => 'pf2e_bestiary';

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
    final cache = await getCache();

    if (cache != null && !forceRefresh) {
      logger.d('Using cached bestiary data');
      data = await decodeCache(cache) ?? [];
      return data;
    }

    try {
      await _getAvailableSources();
    } on DioException catch (e) {
      logger.e(e);
    }

    for (final source in bestiarySources) {
      logger.d('Fetching bestiary data for $source');
      final sourceUri = _availableSources[source];
      if (sourceUri == null) {
        logger.e('Source $source not found');
        continue;
      }
      try {
        final bestiaryResponse =
            await client.get<String>("/bestiaries/$sourceUri");
        final bestiaryData = await compute(
          _decodeBestiaryResponse,
          bestiaryResponse.data!,
        );
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

    if (data.isEmpty && cache != null) {
      logger.d('Request failed. Retrieving from cache');
      data = await decodeCache(cache) ?? [];
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    if (data.isNotEmpty) {
      logger.d('Caching bestiary data');
      await cacheData();
    }
    logger.d('Fetched pf2e bestiary entries');
    return data;
  }
}
