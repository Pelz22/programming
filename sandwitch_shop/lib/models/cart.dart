import 'sandwich.dart';
import '../repositories/pricing_repository.dart';

class CartItem {
	final Sandwich sandwich;
	final int quantity;

	CartItem({required this.sandwich, required this.quantity});
}

class Cart {
	final List<CartItem> _items = [];

	List<CartItem> get items => List.unmodifiable(_items);

	void addItem(Sandwich sandwich, {int quantity = 1}) {
		final index = _items.indexWhere((item) =>
			item.sandwich.type == sandwich.type &&
			item.sandwich.isFootlong == sandwich.isFootlong &&
			item.sandwich.breadType == sandwich.breadType
		);
		if (index != -1) {
			_items[index] = CartItem(
				sandwich: sandwich,
				quantity: _items[index].quantity + quantity,
			);
		} else {
			_items.add(CartItem(sandwich: sandwich, quantity: quantity));
		}
	}

	void removeItem(Sandwich sandwich) {
		_items.removeWhere((item) =>
			item.sandwich.type == sandwich.type &&
			item.sandwich.isFootlong == sandwich.isFootlong &&
			item.sandwich.breadType == sandwich.breadType
		);
	}

	void clear() {
		_items.clear();
	}

	double get totalPrice {
		double total = 0.0;
		for (final item in _items) {
			final size = item.sandwich.isFootlong
				? SandwichSize.footlong
				: SandwichSize.sixInch;
			final pricing = PricingRepository(quantity: item.quantity, size: size);
			total += pricing.totalPrice;
		}
		return total;
	}

	int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
