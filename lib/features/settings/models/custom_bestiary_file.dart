import 'dart:io';

import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/foundation.dart';

class CustomBestiaryFile {
  final String name;
  final File? file;
  final Uint8List? bytes;
  final GameEngineType engine;

  CustomBestiaryFile({
    required this.name,
    this.file,
    this.bytes,
    required this.engine,
  }) : assert(file != null || bytes != null);

  static Map<GameEngineType, String> get fileExtensions => {
        GameEngineType.custom: 'csv',
        GameEngineType.dnd5e: 'json',
        GameEngineType.pf2e: 'json',
      };

  String get extension => fileExtensions[engine]!;
}
