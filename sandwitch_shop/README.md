
# Sandwich Shop App

A Flutter application for ordering custom sandwiches. Users can select sandwich type (Footlong or Six-inch), choose bread, add notes, and adjust quantity with intuitive controls.

## Features

- Select sandwich type: Footlong or Six-inch (toggle switch)
- Choose bread type: White, Wheat, or Wholemeal (dropdown)
- Add special notes (e.g., "no onions")
- Increase or decrease sandwich quantity (with max/min limits)
- Real-time display of current order details

## Installation

1. **Clone the repository:**
	```sh
	git clone https://github.com/yourusername/sandwich_shop.git
	cd sandwich_shop
	```

2. **Install dependencies:**
	```sh
	flutter pub get
	```

3. **Run the app:**
	```sh
	flutter run
	```

## Usage

1. **Select Sandwich Type:**  
	Use the toggle switch to choose between Footlong and Six-inch.

2. **Choose Bread Type:**  
	Use the dropdown menu to select your preferred bread.

3. **Add Notes:**  
	Enter any special instructions in the notes field.

4. **Adjust Quantity:**  
	Use the Add and Remove buttons to set the number of sandwiches (within allowed limits).

5. **View Order:**  
	The order summary updates in real time as you make selections.

## Project Structure

```
sandwitch_shop/
├── lib/
│   ├── main.dart            # Main app logic and UI
│   ├── views/
│   │   └── app_styles.dart  # Custom styles
│   └── repositories/
│       └── order_repository.dart # Order state management
├── README.md
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

Enjoy customizing your sandwich order with the Sandwich Shop App!
