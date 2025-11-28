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

    // initial quantity in UI is 1
    expect(find.text('1'), findsWidgets);

    final addButton = find.widgetWithIcon(IconButton, Icons.add);
    final removeButton = find.widgetWithIcon(IconButton, Icons.remove);
    expect(addButton, findsOneWidget);
    expect(removeButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pump();
    expect(find.text('2'), findsWidgets);

    await tester.tap(removeButton);
    await tester.pump();
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

  testWidgets('shows SnackBar with UNDO when Add to Cart tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Tap the Add to Cart button
    final addToCartFinder = find.text('Add to Cart');
    expect(addToCartFinder, findsOneWidget);
    await tester.tap(addToCartFinder);

    // Allow SnackBar animation to appear
    await tester.pumpAndSettle();

    // Confirm the SnackBar content is shown
    const expectedMessage = 'Added 1 footlong Veggie Delight sandwich(es) on white bread to cart';
    expect(find.text(expectedMessage), findsOneWidget);

    // The SnackBar should include the UNDO action
    expect(find.text('UNDO'), findsOneWidget);

    // Tap UNDO and ensure the SnackBar is dismissed
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text(expectedMessage), findsNothing);
  });
});
}