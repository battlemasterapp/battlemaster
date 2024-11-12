import 'package:battlemaster/api/providers/game_engine_provider.dart';
import 'package:battlemaster/api/services/dnd5e_bestiary_service.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';

class Dnd5eEngineProvider extends GameEngineProvider {
  final Dnd5eBestiaryService _bestiaryService = Dnd5eBestiaryService();

  @override
  Future<void> fetchData({bool forceRefresh = false}) async {
    status = GameEngineProviderStatus.loading;
    notifyListeners();
    await _bestiaryService.fetchData(forceRefresh: forceRefresh);
    status = GameEngineProviderStatus.loaded;
    notifyListeners();
  }

  @override
  List<Combatant> get bestiary => _bestiaryService.bestiaryData;
}
