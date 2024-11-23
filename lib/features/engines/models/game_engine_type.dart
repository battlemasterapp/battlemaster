import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GameEngineType {
  pf2e,
  dnd5e,
  custom,
}

extension Translate on GameEngineType {
  String translate(AppLocalizations localization) {
    switch (this) {
      case GameEngineType.pf2e:
        return localization.game_engine_pf2e;
      case GameEngineType.dnd5e:
        return localization.game_engine_5e;
      case GameEngineType.custom:
        return localization.game_engine_custom;
    }
  }
}