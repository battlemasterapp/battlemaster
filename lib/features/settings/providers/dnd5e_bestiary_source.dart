import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';

enum Dnd5eBestiarySourceStatus {
  loading,
  loaded,
  error,
}

class Dnd5eBestiarySource extends ChangeNotifier {
  Dnd5eBestiarySourceStatus _status = Dnd5eBestiarySourceStatus.loading;
  Map<String, Map<String, String>> _bestiaries = {};

  Dnd5eBestiarySource() {
    load();
  }

  Dnd5eBestiarySourceStatus get status => _status;

  Map<String, Map<String, String>> get bestiaries => _bestiaries;

  Future<void> load() async {
    _status = Dnd5eBestiarySourceStatus.loading;
    notifyListeners();
    final dio = Dio(
        BaseOptions(baseUrl: const String.fromEnvironment('API_5E_URI')))
      ..interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())));
    final response = await dio.get('/v1/documents');
    final sources = (response.data['results'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .fold<Map<String, Map<String, String>>>(
      {},
      (sources, document) =>
          sources..[document['slug']!] = document.cast<String, String>(),
    );
    _bestiaries = sources;
    _status = Dnd5eBestiarySourceStatus.loaded;
    notifyListeners();
  }
}
