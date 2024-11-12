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

class Dnd5eConditionService extends DataService<List<Condition>> {
  Dnd5eConditionService()
      : super(
            baseUrl: const String.fromEnvironment('API_5E_URI'),
            initialData: []);

  @override
  String get cacheKey => '5e_conditions';

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
      logger.d('Using cached bestiary data');
      data = await decodeCache(cache) ?? [];
      return data;
    }

    try {
      final response =
          await client.get<Map<String, dynamic>>('/v2/conditions/');
      final results = (response.data?['results'] as List? ?? [])
          .cast<Map<String, dynamic>>();
      data.addAll(results.map(Condition.from5e));
    } on DioException catch (e) {
      logger.e(e);
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    if (data.isNotEmpty) {
      logger.d('Caching conditions');
      await cacheData();
    }
    logger.d('5e conditions fetched');
    return data;
  }
}
