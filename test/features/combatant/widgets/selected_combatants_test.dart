import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/widgets/selected_combatants.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../build_widget.dart';

void main() {
  Map<Combatant, int> combatants = {};

  setUp(() {
    combatants = {
      Combatant(
        name: 'Player',
        initiative: 1,
        maxHp: 0,
        currentHp: 0,
        armorClass: 0,
        initiativeModifier: 0,
        type: CombatantType.player,
        engineType: GameEngineType.custom,
      ): 1,
      Combatant(
        name: 'Monster',
        initiative: 1,
        maxHp: 0,
        currentHp: 0,
        armorClass: 0,
        initiativeModifier: 0,
        type: CombatantType.monster,
        engineType: GameEngineType.custom,
      ): 2,
    };
  });

  testWidgets('Remove a combatant', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildWidgetTree(
        SelectedCombatants(
          combatants: combatants,
          onCombatantsChanged: (value) {
            combatants = value;
          },
        ),
      ),
    );

    // find combatants
    expect(find.byKey(const Key('combatants-list-tile')), findsNWidgets(2));
    expect(find.byKey(Key('Player-count')), findsOneWidget);
    expect(find.byKey(Key('Monster-count')), findsOneWidget);

    // find button to remove player
    expect(
      find.descendant(
        of: find.byKey(Key('Player-count')),
        matching: find.byKey(const Key('remove-combatant')),
      ),
      findsOneWidget,
    );

    await tester.tap(find.descendant(
      of: find.byKey(Key('Player-count')),
      matching: find.byKey(const Key('remove-combatant')),
    ));
    await tester.pump();
    await tester.pumpWidget(
      buildWidgetTree(
        SelectedCombatants(
          combatants: combatants,
          onCombatantsChanged: (value) {
            combatants = value;
          },
        ),
      ),
    );

    expect(find.byKey(Key('Player-count')), findsNothing);
    expect(find.byKey(Key('Monster-count')), findsOneWidget);
  });

  testWidgets('Add a combatant', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildWidgetTree(
        SelectedCombatants(
          combatants: combatants,
          onCombatantsChanged: (value) {
            combatants = value;
          },
        ),
      ),
    );

    // find combatant
    expect(find.byKey(Key('Monster-count')), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // find button to add combatant
    expect(
      find.descendant(
        of: find.byKey(Key('Monster-count')),
        matching: find.byKey(const Key('add-combatant')),
      ),
      findsOneWidget,
    );

    await tester.tap(find.descendant(
      of: find.byKey(Key('Monster-count')),
      matching: find.byKey(const Key('add-combatant')),
    ));
    await tester.pump();
    await tester.pumpWidget(
      buildWidgetTree(
        SelectedCombatants(
          combatants: combatants,
          onCombatantsChanged: (value) {
            combatants = value;
          },
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
  });
}
