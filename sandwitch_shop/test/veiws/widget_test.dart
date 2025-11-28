import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  // Ensures binding is initialized for image mocking
  TestWidgetsFlutterBinding.ensureInitialized();
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

testWidgets('toggles between six-inch and footlong with Switch (value check)', (WidgetTester tester) async {
  await tester.pumpWidget(const App());

  final switchFinder = find.byType(Switch);
  expect(switchFinder, findsOneWidget);

  // initial value in UI is true (footlong)
  Switch sw = tester.widget<Switch>(switchFinder);
  expect(sw.value, isTrue);

  // toggle it
  await tester.tap(switchFinder);
  await tester.pumpAndSettle();

  sw = tester.widget<Switch>(switchFinder);
  expect(sw.value, isFalse);
});

group('OrderScreen - Quantity', () {
  testWidgets('increments and decrements quantity using IconButtons', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // initial quantity in UI is 1
    expect(find.text('1'), findsWidgets);

    final addButton = find.widgetWithIcon(IconButton, Icons.add);
    final removeButton = find.widgetWithIcon(IconButton, Icons.remove);
    expect(addButton, findsOneWidget);
    expect(removeButton, findsOneWidget);

    // Ensure buttons are visible before tapping (they may be off-screen)
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets);

    await tester.ensureVisible(removeButton);
    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('contains DropdownMenu widgets for sandwich and bread', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
    expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
  });

  testWidgets('StyledButton present with label Add to Cart', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.byType(StyledButton), findsOneWidget);
  });

  testWidgets('Add to cart updates AppBar summary and SnackBar UNDO reverts', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initial summary: no items, zero total.
    expect(find.text('Items: 0'), findsOneWidget);
    expect(find.text('\$0.00'), findsOneWidget);

  // Find and tap the "Add to Cart" button. Ensure it's visible first.
  final Finder addButton = find.text('Add to Cart');
  expect(addButton, findsOneWidget);
  await tester.ensureVisible(addButton);
  await tester.tap(addButton);

  // Let the SnackBar animation complete and the UI update.
  await tester.pumpAndSettle();

  // A SnackBar should be present.
  expect(find.byType(SnackBar), findsOneWidget);

    // The AppBar summary should update to 1 item.
    expect(find.text('Items: 1'), findsOneWidget);

    // The total should no longer be $0.00 after adding an item.
    expect(find.text('\$0.00'), findsNothing);

    // Tap the UNDO action on the SnackBar to revert the add.
    final Finder undoAction = find.text('UNDO');
    expect(undoAction, findsOneWidget);
    await tester.tap(undoAction);

    // Wait for the undo effects and any animations to settle.
    await tester.pumpAndSettle();

    // Summary should be back to zero items and zero total.
    expect(find.text('Items: 0'), findsOneWidget);
    expect(find.text('\$0.00'), findsOneWidget);
  });
});
}