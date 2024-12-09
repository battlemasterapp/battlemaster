import 'package:battlemaster/features/encounter_tracker/widgets/hp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../build_widget.dart';

void main() {
  testWidgets('Quick remove buttons', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 50,
        maxHp: 50,
      ),
    ));

    await tester.tap(find.byKey(Key('-10-hp')));
    await tester.pump();

    expect(find.text('HP: 40'), findsOneWidget);

    await tester.tap(find.byKey(Key('-5-hp')));
    await tester.pump();

    expect(find.text('HP: 35'), findsOneWidget);
  });

  testWidgets('Quick add buttons', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 50,
        maxHp: 100,
      ),
    ));

    await tester.tap(find.byKey(Key('+10-hp')));
    await tester.pump();

    expect(find.text('HP: 60'), findsOneWidget);

    await tester.tap(find.byKey(Key('+5-hp')));
    await tester.pump();

    expect(find.text('HP: 65'), findsOneWidget);
  });

  testWidgets('Hp can\'t be < 0', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 1,
      ),
    ));

    await tester.tap(find.byKey(Key('-10-hp')));
    await tester.pump();

    expect(find.text('HP: 0'), findsOneWidget);
  });

  testWidgets('Hp can\'t be > maxHealth', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 99,
        maxHp: 100,
      ),
    ));

    await tester.tap(find.byKey(Key('+10-hp')));
    await tester.pump();

    expect(find.text('HP: 100'), findsOneWidget);
  });

  testWidgets('maxHp caps at 999 if not specified',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 990,
      ),
    ));

    await tester.tap(find.byKey(Key('+10-hp')));
    await tester.pump();

    expect(find.text('HP: 999'), findsOneWidget);
  });

  testWidgets('damage', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 100,
      ),
    ));

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.text('Damage'));
    await tester.pump();

    expect(find.text('HP: 90'), findsOneWidget);
  });

  testWidgets('heal', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetTree(
      const HpDialog(
        currentHp: 100,
      ),
    ));

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.text('Heal'));
    await tester.pump();

    expect(find.text('HP: 110'), findsOneWidget);
  });
}
