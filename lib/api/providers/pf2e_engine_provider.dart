import 'package:battlemaster/api/providers/game_engine_provider.dart';
import 'package:battlemaster/api/services/pf2e_bestiary_service.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';

class Pf2eEngineProvider extends GameEngineProvider {
  final Set<String> sources;
  final Pf2eBestiaryService _bestiaryService;

  Pf2eEngineProvider({
    required this.sources,
    Pf2eBestiaryService? bestiaryService,
  }) : _bestiaryService =
            bestiaryService ?? Pf2eBestiaryService(bestiarySources: sources);

  @override
  Future<void> fetchData({bool forceRefresh = false}) async {
    status = GameEngineProviderStatus.loading;
    notifyListeners();
    await Future.wait([
      _bestiaryService.fetchData(forceRefresh: forceRefresh),
    ]);
    status = GameEngineProviderStatus.loaded;
    notifyListeners();
  }

  @override
  List<Combatant> get bestiary => _bestiaryService.bestiaryData;

  @override
  Future<void> clearData() async {
    await Future.wait([
      _bestiaryService.deleteCache(),
    ]);
  }

  @override
  // FIXME: do it
  List<Condition> get conditions => [];
}
