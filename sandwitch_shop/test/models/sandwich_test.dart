import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name returns correct string for each type', () {
      expect(Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white).name, 'Veggie Delight');
      expect(Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: false, breadType: BreadType.wheat).name, 'Chicken Teriyaki');
      expect(Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.wholemeal).name, 'Tuna Melt');
      expect(Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.white).name, 'Meatball Marinara');
    });

    test('image returns correct asset path for footlong', () {
      final sandwich = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.white);
      expect(sandwich.image, 'assets/images/tunaMelt_footlong.png');
    });

    test('image returns correct asset path for six-inch', () {
      final sandwich = Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.wheat);
      expect(sandwich.image, 'assets/images/meatballMarinara_six_inch.png');
    });
  });
}
