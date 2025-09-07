import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_template.dart';

class Pf2eAttack {
  final Map<String, dynamic> _entry;
  final Pf2eTemplate template;

  Pf2eAttack({
    required Map<String, dynamic> entry,
    this.template = Pf2eTemplate.normal,
  }) : _entry = entry;

  Map<String, dynamic> get entry => _entry;

  String get name => _entry["name"] ?? "";

  String get range =>
      _entry["system"]?["weaponType"]?["value"] ?? _entry["type"] ?? "";

  int get modifier {
    final baseModifier = _entry["system"]?["bonus"]?["value"] ?? -1;
    return baseModifier + template.attributeModifier;
  }

  String? get damage {
    final Map<String, Map<String, dynamic>>? rolls =
        (_entry["system"]?["damageRolls"] ?? <String, Map<String, dynamic>>{})
            .cast<String, Map<String, dynamic>>();
    if (rolls == null) {
      return null;
    }

    final List<String> damageList = rolls.values
        .map((roll) => "${roll["damage"]} ${roll["damageType"]}")
        .toList();

    if (template == Pf2eTemplate.normal) {
      return damageList.join(" + ");
    }

    return '${damageList.join(" + ")} ${template.attributeModifier.signString}';
  }

  List<String> get effects {
    return _entry["system"]?["attackEffects"]?["value"].cast<String>() ?? [];
  }

  List<String> get traits {
    final List<String> rawTraits =
        _entry["system"]?["traits"]?["value"].cast<String>() ?? [];

    if (rawTraits.isEmpty) {
      return [];
    }

    return rawTraits
        .map((t) => t.replaceAll("<", "").replaceAll(">", ""))
        .toList();
  }

  List<int> get map {
    if (_entry["noMap"] != null) {
      return [];
    }

    int mapValue = 5;
    if (traits.contains("agile")) {
      mapValue = 4;
    }

    return [
      modifier - mapValue,
      modifier - (mapValue * 2),
    ];
  }
}
