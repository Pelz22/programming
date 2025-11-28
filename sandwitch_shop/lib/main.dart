
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';



/// Application entry point. Runs the top-level [App] widget which
/// bootstraps the Material application and loads the `OrderScreen`.
void main() {
  runApp(const App());
}

/// Root widget for the application. Wraps the [OrderScreen] with
/// [MaterialApp] so Material theming and navigation are available.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

/// Screen that allows the user to select sandwich options and add items to a cart.
///
/// `maxQuantity` controls the maximum number of sandwiches that can be ordered
/// through this UI (used by tests and UI constraints).
class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  // Simple in-memory cart for the current session/screen.
  final Cart _cart = Cart();

  // Controller for notes input (wired to a TextField if present).
  final TextEditingController _notesController = TextEditingController();

  // UI selection state: sandwich type, size flag, bread type, and quantity.
  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Listen for changes on the notes controller and rebuild when they occur.
    // This keeps the UI in sync with the text input if notes are displayed
    // elsewhere in the widget tree.
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      // Build a Sandwich model for the current UI selection. The model
      // requires `id`, `description`, and `available`, so we provide
      // simple defaults here (id uses the enum name).
      final Sandwich sandwich = Sandwich(
        id: _selectedSandwichType.name,
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
        description: '',
        available: true,
      );

      // Add the selected sandwich to the cart and update UI.
      setState(() {
        _cart.addItem(sandwich, quantity: _quantity);
      });

      // Developer-facing confirmation printed to console.
      String sizeText = _isFootlong ? 'footlong' : 'six-inch';
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';
      debugPrint(confirmationMessage);

      // Show an on-screen SnackBar confirmation with an UNDO action.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmationMessage),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              // Undo: remove the item that was just added.
              setState(() {
                _cart.removeItem(sandwich);
              });
            },
          ),
        ),
      );
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    // Build entries for the sandwich type dropdown. We create a
    // temporary Sandwich only to reuse the `name` getter for a
    // human-friendly label.
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      // FIX: Add missing fields for Sandwich constructor
      Sandwich sandwich = Sandwich(
        id: type.name,
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
        description: '',
        available: true,
      );
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    // Compute the current sandwich image path by constructing a
    // temporary Sandwich model and returning its `image` value.
    // The model returns the SVG asset path which is rendered via
    // flutter_svg in the UI.
    final Sandwich sandwich = Sandwich(
      id: _selectedSandwichType.name,
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
      description: '',
      available: true,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Print the computed image path for debugging (useful while
    // developing to verify asset names).
    print(_getCurrentImagePath());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
        // Compact cart summary in the app bar actions. Shows current
        // item count and formatted total price. Because cart mutations
        // call setState, these values update automatically.
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Items: ${_cart.totalItems}', style: normalText),
                Text('\$${_cart.totalPrice.toStringAsFixed(2)}', style: normalText),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visual area for the sandwich illustration. The app uses SVG
              // assets (rendered with flutter_svg) so images remain crisp
              // at different device pixel ratios.
              SizedBox(
                height: 300,
                child: SvgPicture.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  // Show a small placeholder widget while the SVG loads.
                  placeholderBuilder: (context) => const Center(
                    child: Text(
                      'Loading image...',
                      style: normalText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  // Changed from heading2 to normalText to avoid undefined style error
                  Text('$_quantity', style: normalText),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

// End of OrderScreen state class.
//
// The StyledButton implementation follows as a top-level widget so it can
// be reused anywhere else in the project.
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}


