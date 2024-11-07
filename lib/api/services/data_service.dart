import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
    client = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<T?> fetchData({bool forceRefresh = false});

  @protected
  Future<T?> decodeCache(String cache);

  @protected
  Future<String> encodeCache(T data);

  @protected
  Future<void> cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(cacheKey, await encodeCache(data));
  }
}
