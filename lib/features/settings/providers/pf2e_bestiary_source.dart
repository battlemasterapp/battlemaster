import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum Pf2eBestiarySourceStatus {
  loading,
  loaded,
  error,
}

class Pf2eBestiarySource extends ChangeNotifier {
  Pf2eBestiarySourceStatus _status = Pf2eBestiarySourceStatus.loading;
  Set<String> _bestiaries = {};

  Pf2eBestiarySource() {
    load();
  }

  Pf2eBestiarySourceStatus get status => _status;

  Set<String> get bestiaries => _bestiaries;

  Future<void> load() async {
    _status = Pf2eBestiarySourceStatus.loading;
    notifyListeners();
    final dio = Dio(BaseOptions(baseUrl: const String.fromEnvironment('PF2E_URI')));
    final response = await dio.get('/bestiaries/index.json');
    final sources = (jsonDecode(response.data) as Map).keys.cast<String>().toSet();
    _bestiaries = sources;
    _status = Pf2eBestiarySourceStatus.loaded;
    notifyListeners();
  }
}
