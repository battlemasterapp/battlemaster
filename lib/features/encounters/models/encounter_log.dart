import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nanoid2/nanoid2.dart';

part 'encounter_log.g.dart';

enum EncounterLogType {
  addCombatant,
  removeCombatant,
  damageCombatant,
  combatantInitiative,
  addConditions,
}

abstract class EncounterLog extends Equatable {
  final String id;
  final int round;
  final int turn;
  final EncounterLogType type;

  EncounterLog({
    required this.round,
    required this.turn,
    required this.type,
    String? id,
  }) : id = id ?? nanoid();

  factory EncounterLog.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'addCombatant':
        return AddCombatantLog.fromJson(json);
      case 'removeCombatant':
        return RemoveCombatantLog.fromJson(json);
      case 'damageCombatant':
        return DamageCombatantLog.fromJson(json);
      case 'combatantInitiative':
        return CombatantInitiativeLog.fromJson(json);
      case 'addConditions':
        return AddConditionsLog.fromJson(json);
      default:
        throw ArgumentError('Invalid EncounterLog type');
    }
  }

  Map<String, dynamic> toJson() {
    switch (type) {
      case EncounterLogType.addCombatant:
        return (this as AddCombatantLog).toJson();
      case EncounterLogType.removeCombatant:
        return (this as RemoveCombatantLog).toJson();
      case EncounterLogType.damageCombatant:
        return (this as DamageCombatantLog).toJson();
      case EncounterLogType.combatantInitiative:
        return (this as CombatantInitiativeLog).toJson();
      case EncounterLogType.addConditions:
        return (this as AddConditionsLog).toJson();
    }
  }

  Encounter apply(Encounter encounter);

  Encounter undo(Encounter encounter);

  String getTitle(AppLocalizations localizations);

  String getDescription(AppLocalizations localizations);

  IconData get icon;

  @override
  List<Object?> get props => [id, round, turn, type];
}

@JsonSerializable()
class AddCombatantLog extends EncounterLog {
  final Combatant combatant;

  AddCombatantLog({
    required super.round,
    required super.turn,
    required this.combatant,
    super.type = EncounterLogType.addCombatant,
    super.id,
  });

  factory AddCombatantLog.fromJson(Map<String, dynamic> json) =>
      _$AddCombatantLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddCombatantLogToJson(this);

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: [...encounter.combatants, combatant],
      logs: [...encounter.logs, this],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants:
          encounter.combatants.where((c) => c.id != combatant.id).toList()
            ..sort((a, b) => b.initiative.compareTo(a.initiative)),
      logs: encounter.logs.where((l) => l != this).toList(),
    );
  }

  @override
  String getTitle(AppLocalizations localizations) =>
      localizations.log_type_add_combatant;

  @override
  String getDescription(AppLocalizations localizations) =>
      localizations.log_type_add_combatant_description(combatant.name);

  @override
  IconData get icon => MingCute.user_add_2_fill;
}

@JsonSerializable()
class RemoveCombatantLog extends EncounterLog {
  final Combatant combatant;

  RemoveCombatantLog({
    required super.round,
    required super.turn,
    required this.combatant,
    super.type = EncounterLogType.removeCombatant,
    super.id,
  });

  factory RemoveCombatantLog.fromJson(Map<String, dynamic> json) =>
      _$RemoveCombatantLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RemoveCombatantLogToJson(this);

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants:
          encounter.combatants.where((c) => c.id != combatant.id).toList(),
      logs: [...encounter.logs, this],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants: [...encounter.combatants, combatant]
        ..sort((a, b) => b.initiative.compareTo(a.initiative)),
      logs: encounter.logs.where((l) => l != this).toList(),
    );
  }

  @override
  String getDescription(AppLocalizations localizations) {
    return localizations.log_type_remove_combatant_description(combatant.name);
  }

  @override
  String getTitle(AppLocalizations localizations) {
    return localizations.log_type_remove_combatant;
  }

  @override
  IconData get icon => MingCute.user_remove_2_fill;
}

@JsonSerializable()
class DamageCombatantLog extends EncounterLog {
  final Combatant combatant;
  final int damage;

  DamageCombatantLog({
    required super.round,
    required super.turn,
    required this.combatant,
    required this.damage,
    super.type = EncounterLogType.damageCombatant,
    super.id,
  });

  bool get isHeal => damage < 0;

  bool get isDamage => damage > 0;

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(
            currentHp: c.currentHp - damage,
          );
        }
        return c;
      }).toList(),
      logs: [...encounter.logs, this],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(
            currentHp: c.currentHp + damage,
          );
        }
        return c;
      }).toList(),
      logs: encounter.logs.where((l) => l != this).toList(),
    );
  }

  factory DamageCombatantLog.fromJson(Map<String, dynamic> json) =>
      _$DamageCombatantLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DamageCombatantLogToJson(this);

  @override
  String getDescription(AppLocalizations localizations) {
    if (isHeal) {
      return localizations.log_type_healed_combatant_description(
          combatant.name, -damage);
    }
    return localizations.log_type_damage_combatant_description(
        combatant.name, damage);
  }

  @override
  String getTitle(AppLocalizations localizations) {
    if (isHeal) {
      return localizations.log_type_healed_combatant;
    }
    return localizations.log_type_damage_combatant;
  }

  @override
  IconData get icon => isHeal ? MingCute.heart_fill : MingCute.heart_crack_fill;
}

@JsonSerializable()
class CombatantInitiativeLog extends EncounterLog {
  final Combatant combatant;
  final double initiative;

  CombatantInitiativeLog({
    required super.round,
    required super.turn,
    required this.combatant,
    required this.initiative,
    super.type = EncounterLogType.combatantInitiative,
    super.id,
  });

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(initiative: initiative);
        }
        return c;
      }).toList()
        ..sort(
          (a, b) => b.initiative.compareTo(a.initiative),
        ),
      logs: [...encounter.logs, this],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(initiative: c.initiative - initiative);
        }
        return c;
      }).toList()
        ..sort((a, b) => b.initiative.compareTo(a.initiative)),
      logs: encounter.logs.where((l) => l != this).toList(),
    );
  }

  factory CombatantInitiativeLog.fromJson(Map<String, dynamic> json) =>
      _$CombatantInitiativeLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatantInitiativeLogToJson(this);

  @override
  String getDescription(AppLocalizations localizations) {
    return localizations.log_type_combatant_initiative_description(
        combatant.name, initiative);
  }

  @override
  String getTitle(AppLocalizations localizations) {
    return localizations.log_type_combatant_initiative;
  }

  @override
  IconData get icon => FontAwesome.dice_d20_solid;
}

@JsonSerializable()
class AddConditionsLog extends EncounterLog {
  final Combatant combatant;
  final List<Condition> conditions;

  AddConditionsLog({
    required super.round,
    required super.turn,
    required this.combatant,
    required this.conditions,
    super.type = EncounterLogType.addConditions,
    super.id,
  });

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(conditions: conditions);
        }
        return c;
      }).toList(),
      logs: [...encounter.logs, this],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(
            conditions: combatant.conditions,
          );
        }
        return c;
      }).toList(),
      logs: encounter.logs.where((l) => l != this).toList(),
    );
  }

  factory AddConditionsLog.fromJson(Map<String, dynamic> json) =>
      _$AddConditionsLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddConditionsLogToJson(this);

  @override
  String getDescription(AppLocalizations localizations) {
    return localizations.log_type_add_conditions_description(
      combatant.name,
      conditions.map((c) => c.name).join(', '),
      conditions.length,
    );
  }

  @override
  String getTitle(AppLocalizations localizations) {
    return localizations.log_type_add_conditions;
  }

  @override
  IconData get icon => MingCute.tag_2_fill;
}
