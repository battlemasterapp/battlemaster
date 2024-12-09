import 'package:battlemaster/common/fonts/action_font.dart';
import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_attack.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_spellcasting.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/recall_knowledge_entry.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../engines/models/game_engine_type.dart';
import '../combatant_data.dart';

part 'pf2e_combatant_data.g.dart';

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

@JsonSerializable()
class Pf2eCombatantData extends CombatantData {
  Pf2eTemplate _template;

  Pf2eCombatantData({
    super.rawData,
    super.engine = GameEngineType.pf2e,
    Pf2eTemplate template = Pf2eTemplate.normal,
  }) : _template = template;

  factory Pf2eCombatantData.fromJson(Map<String, dynamic> json) =>
      _$Pf2eCombatantDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Pf2eCombatantDataToJson(this);

  Pf2eTemplate get template => _template;

  Pf2eTemplate set(Pf2eTemplate template) => _template = template;

  String get name => rawData['name'] ?? "";

  int get hp {
    final baseValue = rawData['system']?['attributes']?['hp']?['value'] ?? 0;
    return baseValue + _template.healthModifier(baseLevel);
  }

  String get hpDetails =>
      rawData['system']?['attributes']?['hp']?['details'] ?? "";

  int? get hardness => rawData['system']?['attributes']?['hardness']?['value'];

  int get ac {
    final baseValue = rawData['system']?['attributes']?['ac']?['value'] ?? 0;
    return baseValue + _template.attributeModifier;
  }

  String get acDetails =>
      rawData['system']?['attributes']?['ac']?['details'] ?? "";

  int get initiativeModifier => rawData['system']?['perception']?['mod'] ?? 0;

  int get baseLevel => rawData['system']?['details']?['level']?['value'] ?? 0;

  int get level {
    return baseLevel + _template.levelModifier;
  }

  String get source =>
      rawData['system']?['details']?['publication']?['title'] ?? '';

  List<String> get traits {
    final rarity = rawData['system']?['traits']?['rarity'];
    String? size = rawData['system']?['traits']?['size']?['value'];

    final sizeMap = {
      'med': 'medium',
      'sm': 'small',
      'grg': 'gargantuan',
      'lg': 'large',
    };

    return <String?>[
      if (rarity != "common") rarity,
      sizeMap[size] ?? size,
      ...rawData['system']['traits']['value'].cast<String>(),
    ].nonNulls.toList();
  }

  RecallKnowledgeEntry get recallKnowledge => RecallKnowledgeEntry(
        traits: traits,
        level: level,
      );

  int get perception {
    final value = rawData["system"]?["perception"]?["mod"] ?? 0;

    return value + _template.attributeModifier;
  }

  List<Pf2eSense> get otherSenses {
    final List<Map<String, dynamic>> rawSenses = rawData["system"]
                ?["perception"]?["senses"]
            ?.cast<Map<String, dynamic>>() ??
        [];

    final detail = rawData["system"]?["perception"]?["details"] ?? "";

    if (detail != "") {
      return [
        ...rawSenses,
        {"type": detail}
      ].map(Pf2eSense.fromJson).toList();
    }

    return rawSenses.map(Pf2eSense.fromJson).toList();
  }

  List<String> get languages =>
      rawData["system"]?["details"]?["languages"]?["value"].cast<String>() ??
      [];

  String get languageDetails =>
      rawData["system"]?["details"]?["languages"]?["details"] ?? "";

  List<Pf2eSkill> get skills {
    final Map<String, Map> rawSkillsMap =
        rawData["system"]?["skills"].cast<String, Map>() ?? <String, Map>{};

    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    final loreEntries = rawEntries
        .where(
          (entry) => entry["type"] == "lore",
        )
        .toList();

    if (rawSkillsMap.isEmpty && loreEntries.isEmpty) {
      return [];
    }

    final skills = <String, int>{};
    for (final skill in rawSkillsMap.entries) {
      skills[skill.key] = skill.value["base"] + _template.attributeModifier;
    }
    for (final lore in loreEntries) {
      final loreName = lore["name"];
      final loreValue = lore["system"]?["mod"]?["value"] ?? 0;
      skills[loreName] = loreValue + _template.attributeModifier;
    }

    return skills.entries.map((entry) {
      return Pf2eSkill(entry.key, entry.value);
    }).toList();
  }

  Pf2eAttributes get strength {
    final mod = rawData["system"]?["abilities"]?["str"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["str"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  Pf2eAttributes get dexterity {
    final mod = rawData["system"]?["abilities"]?["dex"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["dex"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  Pf2eAttributes get constitution {
    final mod = rawData["system"]?["abilities"]?["con"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["con"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  Pf2eAttributes get intelligence {
    final mod = rawData["system"]?["abilities"]?["int"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["int"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  Pf2eAttributes get wisdom {
    final mod = rawData["system"]?["abilities"]?["wis"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["wis"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  Pf2eAttributes get charisma {
    final mod = rawData["system"]?["abilities"]?["cha"]?["mod"] ?? 0;
    final value = rawData["system"]?["abilities"]?["cha"]?["value"] ?? 0;

    return Pf2eAttributes(value, mod);
  }

  List<String> get items {
    final List<Map<String, dynamic>> rawItems =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    const itemTypes = [
      "weapon",
      "consumable",
      "armor",
      "equipment",
      "shield",
    ];

    return rawItems
        .where((item) => itemTypes.contains(item["type"]))
        .map((item) {
          final name = item["name"];
          final quantity = item["system"]?["quantity"];
          final int hardness = item["system"]?["hardness"] ?? 0;
          final int hp = item["system"]?["hp"]?["max"] ?? 0;

          if (hardness > 0 && hp > 0) {
            return "$name (Hardness $hardness, HP $hp, BT ${(hp / 2).floor()})";
          }

          return quantity == 1 ? name : "$name ($quantity)";
        })
        .cast<String>()
        .toList()
      ..sort();
  }

  int get fortitude {
    final value = rawData["system"]?["saves"]?["fortitude"]?["value"] ?? 0;
    return value + _template.attributeModifier;
  }

  int get reflex {
    final value = rawData["system"]?["saves"]?["reflex"]?["value"] ?? 0;
    return value + _template.attributeModifier;
  }

  int get will {
    final value = rawData["system"]?["saves"]?["will"]?["value"] ?? 0;
    return value + _template.attributeModifier;
  }

  List<String> get immunities =>
      rawData["system"]?["attributes"]?["immunities"]
          ?.cast<Map<String, dynamic>>()
          .map((e) => e['type'])
          .toList()
          .cast<String>() ??
      [];

  List<Pf2eResistanceWeakness> get resistances {
    final List<Map<String, dynamic>> rawResistances = rawData["system"]
                ?["attributes"]?["resistances"]
            ?.cast<Map<String, dynamic>>() ??
        [];

    return rawResistances.map((resistance) {
      final name = resistance["type"];
      final value = resistance["value"] ?? 0;

      return Pf2eResistanceWeakness(
        name,
        value,
        exceptions: resistance["exceptions"]?.cast<String>() ?? <String>[],
      );
    }).toList();
  }

  List<Pf2eResistanceWeakness> get weaknesses {
    final List<Map<String, dynamic>> rawResistances = rawData["system"]
                ?["attributes"]?["weaknesses"]
            ?.cast<Map<String, dynamic>>() ??
        [];

    return rawResistances.map((resistance) {
      final name = resistance["type"];
      final value = resistance["value"] ?? 0;

      return Pf2eResistanceWeakness(name, value);
    }).toList();
  }

  int get baseSpeed =>
      rawData["system"]?["attributes"]?["speed"]?["value"] ?? 0;

  List<Pf2eSpeed> get otherSpeeds {
    final List rawSpeeds =
        rawData["system"]?["attributes"]?["speed"]?["otherSpeeds"] ?? [];

    return rawSpeeds.map((s) => Pf2eSpeed(s["type"], s["value"])).toList();
  }

  List<Pf2eAttack> get attacks {
    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    return rawEntries
        .where(
          (entry) => entry["type"] == "melee",
        )
        .map((entry) => Pf2eAttack(
              entry: entry,
              template: template,
            ))
        .toList();
  }

  List<Pf2eSpecialAbility> get topAbilities {
    // top abilities are interaction abilities
    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    final defensiveAbilities = rawEntries
        .where(
          (entry) => entry["system"]?["category"] == "interaction",
        )
        .map((entry) => Pf2eSpecialAbility(entry))
        .toList();
    return defensiveAbilities;
  }

  List<Pf2eSpecialAbility> get midAbilities {
    // Mid abilities are defensive abilities
    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    final defensiveAbilities = rawEntries
        .where(
          (entry) {
            final String description =
                entry["system"]?["description"]?["value"] ?? "";
            return entry["system"]?["category"] == "defensive" &&
                description.isNotEmpty;
          },
        )
        .map((entry) => Pf2eSpecialAbility(entry))
        .toList();
    return defensiveAbilities;
  }

  List<Pf2eSpecialAbility> get botAbilities {
    // bottom abilities are offensive abilities
    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    final defensiveAbilities = rawEntries
        .where(
          (entry) => entry["system"]?["category"] == "offensive",
        )
        .map((entry) => Pf2eSpecialAbility(entry))
        .toList();
    return defensiveAbilities;
  }

  List<Pf2eSpellcasting> get spellcasting {
    final List<Map<String, dynamic>> rawEntries =
        (rawData["items"] ?? []).cast<Map<String, dynamic>>();

    return rawEntries
        .where(
      (entry) => entry["type"] == "spellcastingEntry",
    )
        .map((spellcasting) {
      final spells = rawEntries
          .where(
            (entry) =>
                entry["type"] == "spell" &&
                entry["system"]?["location"]?["value"] == spellcasting["_id"],
          )
          .toList();
      spellcasting["spells"] = spells;
      return Pf2eSpellcasting(
        spellcasting,
        template: template,
        characterLevel: baseLevel,
      );
    }).toList();
  }
}

class Pf2eSense {
  final String type;
  final String? acuity;
  final int? range;

  Pf2eSense({
    required this.type,
    this.acuity,
    this.range,
  });

  factory Pf2eSense.fromJson(Map<String, dynamic> json) {
    final type = json["type"] as String;
    final acuity = json["acuity"] as String?;
    final range = json["range"] as int?;

    return Pf2eSense(
      type: type,
      acuity: acuity,
      range: range,
    );
  }

  @override
  String toString() {
    final acuityString = acuity != null ? "($acuity)" : "";
    final rangeString = range != null ? " $range ft." : "";

    return "$type $acuityString$rangeString";
  }
}

class Pf2eSkill {
  final String name;
  final int modifier;

  Pf2eSkill(this.name, this.modifier);

  @override
  String toString() {
    return "$name ${modifier.signString}";
  }
}

class Pf2eAttributes {
  final int attribute;
  final int modifier;

  Pf2eAttributes(this.attribute, this.modifier);
}

class Pf2eResistanceWeakness {
  final String name;
  final int value;
  final List<String> exceptions;

  const Pf2eResistanceWeakness(
    this.name,
    this.value, {
    this.exceptions = const [],
  });

  @override
  String toString() {
    if (exceptions.isEmpty) {
      return "$name $value";
    }
    return "$name $value (except ${exceptions.join(", ")})";
  }
}

class Pf2eSpeed {
  final String name;
  final int speed;

  Pf2eSpeed(this.name, this.speed);

  @override
  String toString() {
    return "$name $speed feet";
  }
}

class Pf2eSpecialAbility {
  final Map<String, dynamic> rawData;

  Pf2eSpecialAbility(this.rawData);

  String get name => rawData["name"];

  List<ActionsEnum> get actions {
    final actionType = rawData["system"]?["actionType"]?["value"];

    if (actionType == null) {
      return [];
    }

    if (actionType == "free") {
      return [ActionsEnum.free];
    }

    if (actionType == "reaction") {
      return [ActionsEnum.reaction];
    }

    if (actionType == "action") {
      final int? actionCost = rawData["system"]?["actions"]?["value"];

      if (actionCost == null) {
        return [];
      }

      switch (actionCost) {
        case 1:
          return [ActionsEnum.one];
        case 2:
          return [ActionsEnum.two];
        case 3:
          return [ActionsEnum.three];
      }
    }

    return [];
  }

  String get description => rawData["system"]?["description"]?["value"] ?? "";

  List<String> get traits {
    return rawData["system"]?["traits"]?['value']?.cast<String>() ?? [];
  }
}
