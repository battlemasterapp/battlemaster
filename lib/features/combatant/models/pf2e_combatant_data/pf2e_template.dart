import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum Pf2eTemplate {
  weak,
  normal,
  elite,
}

extension TemplateValues on Pf2eTemplate {
  int get levelModifier {
    switch (this) {
      case Pf2eTemplate.weak:
        return -1;
      case Pf2eTemplate.normal:
        return 0;
      case Pf2eTemplate.elite:
        return 1;
    }
  }

  int get attributeModifier {
    switch (this) {
      case Pf2eTemplate.weak:
        return -2;
      case Pf2eTemplate.normal:
        return 0;
      case Pf2eTemplate.elite:
        return 2;
    }
  }

  int healthModifier(int baseLevel) {
    if (this == Pf2eTemplate.normal) {
      return 0;
    }

    final templateMap = {
      Pf2eTemplate.weak: <int, int>{
        2: -10,
        5: -15,
        20: -20,
        100: -30,
      },
      Pf2eTemplate.elite: <int, int>{
        1: 10,
        4: 15,
        19: 20,
        100: 30,
      },
    };

    final modifierMap = templateMap[this]!;
    return modifierMap.entries
        .firstWhere(
          (entry) => baseLevel <= entry.key,
          orElse: () => modifierMap.entries.last,
        )
        .value;
  }
}

extension Translate on Pf2eTemplate {
  String translate(AppLocalizations localization) {
    switch (this) {
      // FIXME: textos
      case Pf2eTemplate.weak:
        return 'weak';
      case Pf2eTemplate.normal:
        return '';
      case Pf2eTemplate.elite:
        return 'elite';
    }
  }
}