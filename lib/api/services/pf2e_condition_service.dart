import 'dart:convert';

import 'package:battlemaster/api/services/data_service.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

String _encodeConditions(List<Condition> data) {
  return jsonEncode(data.map((e) => e.toJson()).toList());
}

List<Condition> _decodeCondition(String cache) {
  final list = (jsonDecode(cache) as List).cast<Map<String, dynamic>>();
  return list.map((e) => Condition.fromJson(e)).toList();
}

class Pf2eConditionService extends DataService<List<Condition>> {
  Pf2eConditionService()
      : super(
            baseUrl: const String.fromEnvironment('PF2E_URI'), initialData: []);

  @override
  String get cacheKey => 'pf2e_conditions';

  List<Condition> get conditions => data;

  @override
  Future<List<Condition>?> decodeCache(String cache) async {
    return await compute(
      _decodeCondition,
      cache,
    );
  }

  @override
  Future<String> encodeCache(List<Condition> data) async {
    return await compute(
      _encodeConditions,
      data,
    );
  }

  @override
  Future<List<Condition>?> fetchData({bool forceRefresh = false}) async {
    data.clear();
    final cache = await getCache();

    if (cache != null && !forceRefresh) {
      logger.d('Using cached conditions data');
      data = await decodeCache(cache) ?? [];
      return data;
    }

    try {
      logger.d('Fetching conditions');
      final response = await client.get<String>('/conditions/conditions.json');
      final results = (jsonDecode(response.data ?? '[]') as List? ?? [])
          .cast<Map<String, dynamic>>();
      data.addAll(results.map(Condition.fromPf2e));
    } on DioException catch (e) {
      logger.e(e);
      if (cache != null) {
        logger.d('Request failed. Retrieving from cache');
        data = await decodeCache(cache) ?? [];
      }
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    if (data.isNotEmpty) {
      logger.d('Caching conditions');
      await cacheData();
    }
    logger.d('PF2e conditions fetched');
    return data;
  }
}
