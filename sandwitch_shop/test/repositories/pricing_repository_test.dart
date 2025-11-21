import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('calculates price for six-inch sandwiches', () {
      final repo = PricingRepository(quantity: 2, size: SandwichSize.sixInch);
      expect(repo.totalPrice, 14.0);
    });

    test('calculates price for footlong sandwiches', () {
      final repo = PricingRepository(quantity: 3, size: SandwichSize.footlong);
      expect(repo.totalPrice, 33.0);
    });

    test('zero quantity returns zero price', () {
      final repo = PricingRepository(quantity: 0, size: SandwichSize.footlong);
      expect(repo.totalPrice, 0.0);
    });
  });
}