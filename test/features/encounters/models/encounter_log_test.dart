import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final encounter = Encounter(
    name: 'Test',
    combatants: [],
    logs: [],
    engine: GameEngineType.custom,
  );

  final combatant = Combatant(
    id: 'goblin',
    name: 'Goblin',
    initiative: 0,
    maxHp: 10,
    currentHp: 10,
    armorClass: 10,
    engineType: GameEngineType.custom,
    initiativeModifier: 0,
    type: CombatantType.monster,
  );

  setUp(() {
    encounter.combatants.clear();
  });

  test('Add combatant', () {
    final encounterLog = AddCombatantLog(
      round: 1,
      turn: 1,
      combatant: combatant,
    );

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.length, 1);
    expect(updateEncounter.combatants.first, combatant);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.length, 0);
  });

  test('Remove combatant', () {
    encounter.combatants.add(combatant);

    final encounterLog = RemoveCombatantLog(
      round: 1,
      turn: 1,
      combatant: combatant,
    );

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.length, 0);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.length, 1);
    expect(undoEncounter.combatants.first, combatant);
  });

  test('Damage combatant', () {
    encounter.combatants.add(combatant);

    final encounterLog = DamageCombatantLog(
      round: 1,
      turn: 1,
      combatant: combatant,
      damage: 5,
    );

    expect(encounterLog.isDamage, true);

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.first.currentHp, 5);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.first.currentHp, 10);
  });

  test('Heal combatant', () {
    encounter.combatants.add(combatant);

    final encounterLog = DamageCombatantLog(
      round: 1,
      turn: 1,
      combatant: combatant,
      damage: -5,
    );

    expect(encounterLog.isHeal, true);

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.first.currentHp, 15);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.first.currentHp, 10);
  });

  test('Combatant initiative', () {
    final topCombatant = Combatant(
      id: 'top',
      name: 'Top',
      initiative: 10,
      maxHp: 10,
      currentHp: 10,
      armorClass: 10,
      engineType: GameEngineType.custom,
      initiativeModifier: 0,
      type: CombatantType.monster,
    );

    encounter.combatants.addAll([topCombatant, combatant]);

    final encounterLog = CombatantInitiativeLog(
      round: 1,
      turn: 1,
      combatant: combatant,
      initiative: 20,
    );

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.first, combatant);
    expect(updateEncounter.combatants.last, topCombatant);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.first, topCombatant);
    expect(undoEncounter.combatants.last, combatant);
  });

  test('Add conditions', () {
    final condition = Condition(
      name: 'Poisoned',
      description: 'Poisoned',
    );

    final encounterLog = AddConditionsLog(
      round: 1,
      turn: 1,
      combatant: combatant,
      conditions: [condition],
    );

    encounter.combatants.add(combatant);

    final updateEncounter = encounterLog.apply(encounter);
    expect(updateEncounter.combatants.first.conditions.length, 1);
    expect(updateEncounter.combatants.first.conditions.first, condition);

    final undoEncounter = encounterLog.undo(updateEncounter);
    expect(undoEncounter.combatants.first.conditions.length, 0);
  });
}
