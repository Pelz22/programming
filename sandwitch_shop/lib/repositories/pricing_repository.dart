enum SandwichSize { sixInch, footlong }

class PricingRepository {
  final int quantity;
  final SandwichSize size;

  PricingRepository({required this.quantity, required this.size});

  double get totalPrice {
    double pricePerSandwich = size == SandwichSize.sixInch ? 7.0 : 11.0;
    return pricePerSandwich * quantity;
  }
}