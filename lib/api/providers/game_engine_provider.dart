import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:flutter/foundation.dart';

enum GameEngineProviderStatus {
  loading,
  loaded,
  error,
}

abstract class GameEngineProvider extends ChangeNotifier {
  @protected
  GameEngineProviderStatus status = GameEngineProviderStatus.loading;

  GameEngineProviderStatus get currentStatus => status;

  List<Combatant> get bestiary;

  List<Condition> get conditions;

  Future<void> fetchData({bool forceRefresh = false});
}
