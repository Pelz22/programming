import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    final sandwich1 = Sandwich(
      id: SandwichType.veggieDelight.name,
      type: SandwichType.veggieDelight,
      isFootlong: true,
      breadType: BreadType.white,
      description: '',
      available: true,
    );
    final sandwich2 = Sandwich(
      id: SandwichType.chickenTeriyaki.name,
      type: SandwichType.chickenTeriyaki,
      isFootlong: false,
      breadType: BreadType.wheat,
      description: '',
      available: true,
    );

    test('addItem adds items to cart', () {
      final cart = Cart();
      cart.addItem(sandwich1);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 1);
      cart.addItem(sandwich1);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      cart.addItem(sandwich2, quantity: 3);
      expect(cart.items.length, 2);
      expect(cart.items[1].quantity, 3);
    });

    test('removeItem removes items from cart', () {
      final cart = Cart();
      cart.addItem(sandwich1);
      cart.addItem(sandwich2);
      expect(cart.items.length, 2);
      cart.removeItem(sandwich1);
      expect(cart.items.length, 1);
      expect(cart.items.first.sandwich, sandwich2);
    });

    test('clear empties the cart', () {
      final cart = Cart();
      cart.addItem(sandwich1);
      cart.addItem(sandwich2);
      cart.clear();
      expect(cart.items.length, 0);
    });

    test('totalPrice calculates correctly', () {
      final cart = Cart();
      cart.addItem(sandwich1, quantity: 2); // footlong: £11 each
      cart.addItem(sandwich2, quantity: 1); // six-inch: £7 each
      expect(cart.totalPrice, 11.0 * 2 + 7.0 * 1);
    });

    test('totalItems returns correct count', () {
      final cart = Cart();
      cart.addItem(sandwich1, quantity: 2);
      cart.addItem(sandwich2, quantity: 3);
      expect(cart.totalItems, 5);
    });
  });
}
