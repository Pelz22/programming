import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name returns correct string for each type', () {
      expect(
        Sandwich(
          id: SandwichType.veggieDelight.name,
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
          description: '',
          available: true,
        ).name,
        'Veggie Delight',
      );
      expect(
        Sandwich(
          id: SandwichType.chickenTeriyaki.name,
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
          description: '',
          available: true,
        ).name,
        'Chicken Teriyaki',
      );
      expect(
        Sandwich(
          id: SandwichType.tunaMelt.name,
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal,
          description: '',
          available: true,
        ).name,
        'Tuna Melt',
      );
      expect(
        Sandwich(
          id: SandwichType.meatballMarinara.name,
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white,
          description: '',
          available: true,
        ).name,
        'Meatball Marinara',
      );
    });

    test('image returns correct asset path for footlong', () {
      final sandwich = Sandwich(
        id: SandwichType.tunaMelt.name,
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.white,
        description: '',
        available: true,
      );
      expect(sandwich.image, 'assets/images/tunaMelt_footlong.svg');
    });

    test('image returns correct asset path for six-inch', () {
      final sandwich = Sandwich(
        id: SandwichType.meatballMarinara.name,
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wheat,
        description: '',
        available: true,
      );
      expect(sandwich.image, 'assets/images/meatballMarinara_six_inch.svg');
    });
  });
}
