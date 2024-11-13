import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DataService<T> {
  @protected
  final String baseUrl;

  @protected
  late Dio client;

  @protected
  late T data;

  @protected
  final logger = Logger();

  String get cacheKey;

  DataService({
    required this.baseUrl,
    required T initialData,
  }) {
    data = initialData;
    client = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.add(
          DioCacheInterceptor(options: CacheOptions(store: MemCacheStore())));
  }

  Future<T?> fetchData({bool forceRefresh = false});

  @protected
  Future<T?> decodeCache(String cache);

  @protected
  Future<String> encodeCache(T data);

  @protected
  Future<String?> getCache() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      logger.d('Reading cache from shared prefs');
      return prefs.getString(cacheKey);
    }
    final cacheDir = await getApplicationCacheDirectory();
    final cacheFile = '${cacheDir.path}/$cacheKey.json';
    final fileExists = await File(cacheFile).exists();
    if (!fileExists) {
      return null;
    }
    logger.d('Reading cache from $cacheFile');
    return await File(cacheFile).readAsString();
  }

  @protected
  Future<void> cacheData() async {
    if (kIsWeb) {
      // Cache on shared prefs
      final prefs = await SharedPreferences.getInstance();
      logger.d('Writing cache to shared prefs');
      prefs.setString(cacheKey, await encodeCache(data));
      return;
    }
    final cacheDir = await getApplicationCacheDirectory();
    final cacheFile = '${cacheDir.path}/$cacheKey.json';
    logger.d('Writing cache to $cacheFile');
    await File(cacheFile).writeAsString(await encodeCache(data));
  }

  Future<void> deleteCache() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      logger.d('Deleting cache from shared prefs');
      prefs.remove(cacheKey);
      return;
    }
    final cacheDir = await getApplicationCacheDirectory();
    final cacheFile = '${cacheDir.path}/$cacheKey.json';
    logger.d('Deleting cache from $cacheFile');
    await File(cacheFile).delete();
  }

}
