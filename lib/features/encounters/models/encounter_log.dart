import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encounter_log.g.dart';

enum EncounterLogType {
  addCombatant,
  removeCombatant,
  damageCombatant,
  combatantInitiative,
  addConditions,
}

abstract class EncounterLog {
  final int round;
  final int turn;
  final EncounterLogType type;

  EncounterLog({
    required this.round,
    required this.turn,
    required this.type,
  });

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
}

@JsonSerializable()
class AddCombatantLog extends EncounterLog {
  final Combatant combatant;

  AddCombatantLog({
    required super.round,
    required super.turn,
    required this.combatant,
    super.type = EncounterLogType.addCombatant,
  });

  factory AddCombatantLog.fromJson(Map<String, dynamic> json) =>
      _$AddCombatantLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddCombatantLogToJson(this);

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: [...encounter.combatants, combatant],
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants:
          encounter.combatants.where((c) => c.id != combatant.id).toList(),
    );
  }
}

@JsonSerializable()
class RemoveCombatantLog extends EncounterLog {
  final Combatant combatant;

  RemoveCombatantLog({
    required super.round,
    required super.turn,
    required this.combatant,
    super.type = EncounterLogType.removeCombatant,
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
    );
  }

  @override
  Encounter undo(Encounter encounter) {
    return encounter.copyWith(
      combatants: [...encounter.combatants, combatant],
    );
  }
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
    );
  }

  factory DamageCombatantLog.fromJson(Map<String, dynamic> json) =>
      _$DamageCombatantLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DamageCombatantLogToJson(this);
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
  });

  @override
  Encounter apply(Encounter encounter) {
    return encounter.copyWith(
      combatants: encounter.combatants.map((c) {
        if (c.id == combatant.id) {
          return c.copyWith(initiative: initiative);
        }
        return c;
      }).toList()..sort((a, b) => b.initiative.compareTo(a.initiative),),
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
      }).toList(),
    );
  }

  factory CombatantInitiativeLog.fromJson(Map<String, dynamic> json) =>
      _$CombatantInitiativeLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CombatantInitiativeLogToJson(this);
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
    );
  }

  factory AddConditionsLog.fromJson(Map<String, dynamic> json) =>
      _$AddConditionsLogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddConditionsLogToJson(this);
}
