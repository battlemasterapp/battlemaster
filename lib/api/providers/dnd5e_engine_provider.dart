import 'package:battlemaster/api/providers/game_engine_provider.dart';
import 'package:battlemaster/api/services/dnd5e_bestiary_service.dart';
import 'package:battlemaster/api/services/dnd5e_condition_service.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';

class Dnd5eEngineProvider extends GameEngineProvider {
  final Set<String> sources;
  final Dnd5eBestiaryService _bestiaryService;
  final Dnd5eConditionService _conditionService;

  Dnd5eEngineProvider({
    required this.sources,
    Dnd5eBestiaryService? bestiaryService,
    Dnd5eConditionService? conditionsService,
  })  : _bestiaryService = bestiaryService ?? Dnd5eBestiaryService(bestiarySources: sources),
        _conditionService = conditionsService ?? Dnd5eConditionService();

  @override
  Future<void> fetchData({bool forceRefresh = false}) async {
    status = GameEngineProviderStatus.loading;
    notifyListeners();
    await Future.wait([
      _conditionService.fetchData(forceRefresh: forceRefresh),
      _bestiaryService.fetchData(forceRefresh: forceRefresh),
    ]);
    status = GameEngineProviderStatus.loaded;
    notifyListeners();
  }

  @override
  List<Combatant> get bestiary => _bestiaryService.bestiaryData;

  @override
  List<Condition> get conditions => _conditionService.conditions;

  @override
  Future<void> clearData() async {
    await Future.wait([
      _conditionService.deleteCache(),
      _bestiaryService.deleteCache(),
    ]);
  }
}
