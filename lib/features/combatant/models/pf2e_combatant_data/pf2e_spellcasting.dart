import 'dart:math';

import 'package:battlemaster/common/fonts/action_font.dart';
import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';

class Pf2eSpellcasting {
  final Map<String, dynamic> _entry;
  final Pf2eTemplate template;
  final int characterLevel;

  Pf2eSpellcasting(
    Map<String, dynamic> entry, {
    this.template = Pf2eTemplate.normal,
    this.characterLevel = 0,
  }) : _entry = entry;

  @override
  String toString() => raw.toString();

  Map<String, dynamic> get raw => _entry;

  String? get name => _entry["name"];

  String? get tradition => _entry["system"]?["tradition"]?["value"];

  String? get type => _entry["type"];

  int get dc {
    final baseDC = _entry["system"]["spelldc"]["dc"] ?? -1;
    if (template == Pf2eTemplate.normal) {
      return baseDC;
    }
    return baseDC + template.attributeModifier;
  }

  int? get attack {
    final baseAttack = _entry["system"]["spelldc"]["value"];
    if (baseAttack == null) {
      return null;
    }

    if (template == Pf2eTemplate.normal) {
      return baseAttack;
    }
    return baseAttack + template.attributeModifier;
  }

  SpellcastingLevelEntry? get cantrips {
    final rawCantrips = (_entry["spells"] as List<Map<String, dynamic>>? ??
            <Map<String, dynamic>>[])
        .where((spell) =>
            spell["system"]?["traits"]?["value"]?.contains("cantrip") ?? false)
        .toList();

    return rawCantrips.isEmpty
        ? null
        : SpellcastingLevelEntry(
            spells: rawCantrips,
            level: max(1, (characterLevel / 2).ceil()),
          );
  }

  List<SpellcastingLevelEntry>? get spells {
    // TODO: detemine spells by the type (prepared/spontaneous)
    final List<Map<String, dynamic>> nonCantrips =
        (_entry["spells"] as List<Map<String, dynamic>>? ??
                <Map<String, dynamic>>[])
            .where(
              (spell) =>
                  !(spell["system"]?["traits"]?["value"]?.contains("cantrip") ??
                      false),
            )
            .toList();

    // if spellcasting is from focus, all spells are the same level
    final isFocus = _entry["system"]?["prepared"]?["value"] == "focus";

    if (isFocus) {
      return [
        SpellcastingLevelEntry(
          spells: nonCantrips,
          level: (characterLevel / 2).ceil(),
        ),
      ];
    }

    final isPrepared = _entry["system"]?["prepared"]?["value"] == "prepared";
    final slots = _entry["system"]?["slots"] as Map<String, dynamic>? ?? {};
    slots.remove("slot0");

    if (isPrepared && slots.isNotEmpty) {
      final Map<String, Map<String, dynamic>> spellsById =
          (_entry["spells"] as List<Map<String, dynamic>>)
              .fold<Map<String, Map<String, dynamic>>>(
        <String, Map<String, dynamic>>{},
        (map, spell) {
          map[spell["_id"]] = spell;
          return map;
        },
      );
      // if the spellcasting is prepared, the spells are grouped in the slots section
      return slots.entries.map((slot) {
        final level = int.tryParse(slot.key.replaceAll("slot", "")) ?? 1;
        final preparedSpells = (slot.value["prepared"] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map((prepSpell) => spellsById[prepSpell["id"]])
            .toList()
            .cast<Map<String, dynamic>>();
        return SpellcastingLevelEntry(spells: preparedSpells, level: level);
      }).toList()
        ..sort((a, b) => a.level.compareTo(b.level));
    }

    final levels = <int, List<Map<String, dynamic>>>{};

    for (final spell in nonCantrips) {
      final level = spell["system"]?["location"]?["heightenedLevel"] ??
          spell["system"]?["level"]?["value"] ??
          0;
      levels.putIfAbsent(level, () => <Map<String, dynamic>>[]);
      levels[level]!.add(spell);
    }

    levels.remove(0);

    return levels.entries.map(
      (entry) {
        final slots = _entry["system"]?["slots"]?["slot${entry.key}"]?["max"];
        return SpellcastingLevelEntry(
          spells: entry.value,
          level: entry.key,
          slots: slots,
        );
      },
    ).toList()
      ..sort((a, b) => a.level.compareTo(b.level));
  }
}

class SpellcastingLevelEntry {
  final List<Map<String, dynamic>> _spells;
  final int level;
  final int? slots;

  SpellcastingLevelEntry({
    required List<Map<String, dynamic>> spells,
    this.level = 1,
    this.slots,
  }) : _spells = spells;

  List<Map<String, dynamic>> get raw => _spells;

  bool get constant => false;

  List<Pf2eSpellEntry> get spells =>
      _spells.map((e) => Pf2eSpellEntry(e, level)).toList();

  List<SpellcastingLevelEntry> get constantSpells {
    return [];
  }
}

class Pf2eSpellEntry {
  final Map<String, dynamic> _entry;
  final int level;

  Pf2eSpellEntry(
    Map<String, dynamic> entry,
    this.level,
  ) : _entry = entry;

  Map<String, dynamic> get raw => _entry;

  String get name => _entry["name"] ?? "";

  List<String> get traits {
    final Map rawTraits = _entry["system"]?["traits"] ?? {};

    return [
      rawTraits["rarity"],
      ...(rawTraits["value"] ?? []),
    ].whereType<String>().toList();
  }

  bool get isCantrip => traits.contains("cantrip");

  List<String> get traditions {
    final Map rawTraits = _entry["system"]?["traits"] ?? {};
    return [
      ...(rawTraits["traditions"] ?? []),
    ].whereType<String>().toList();
  }

  List<ActionsEnum> get actions {
    final String? activity = _entry["system"]?["time"]?["value"];

    if (activity == null) {
      return [];
    }

    if (activity == "free") {
      return [ActionsEnum.free];
    }

    if (activity == "reaction") {
      return [ActionsEnum.reaction];
    }

    const activityMap = {
      "1": [ActionsEnum.one],
      "2": [ActionsEnum.two],
      "3": [ActionsEnum.three],
      "1 to 2": [ActionsEnum.one, ActionsEnum.two],
      "1 to 3": [ActionsEnum.one, ActionsEnum.three],
    };

    return activityMap[activity] ?? [];
  }

  String get range => _entry["system"]?["range"]?["value"] ?? "";

  String get targets => _entry["system"]?["target"]?["value"] ?? "";

  int? get amount => _entry["system"]?["location"]?["uses"]?["max"];

  String? get area {
    final area = _entry["system"]?["area"];

    if (area == null) {
      return null;
    }

    return "${area["value"]}-foot ${area["type"]}";
  }

  String get duration => _entry["system"]?["duration"]?["value"] ?? "";

  bool get isSustained => _entry["system"]?["duration"]?["sustained"] ?? false;

  bool get isBasicSave =>
      _entry["system"]?["defense"]?["save"]?["basic"] ?? false;

  String get defense {
    final saveDefense = _entry["system"]?["defense"]?["save"];

    if (saveDefense == null) {
      return "";
    }

    final String statistic = saveDefense["statistic"] ?? "";

    return statistic.capitalize();
  }

  String get description {
    return _entry["system"]?["description"]?["value"] ?? "";
  }
}

class HeightenedEntry {
  final String level;
  final List<String> entries;

  HeightenedEntry({required this.level, required this.entries});
}
