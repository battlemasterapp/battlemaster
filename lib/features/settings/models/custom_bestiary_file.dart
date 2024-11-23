import 'dart:io';

import 'package:battlemaster/features/engines/models/game_engine_type.dart';

class  CustomBestiaryFile {
  final String name;
  final File file;
  final GameEngineType engine;

  CustomBestiaryFile({
    required this.name,
    required this.file,
    required this.engine,
  });
}