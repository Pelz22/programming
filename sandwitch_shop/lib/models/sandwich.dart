import 'dart:convert';
import 'package:flutter/services.dart';
Future<List<Map<String, dynamic>>> loadSandwichData() async {
  final String jsonString = await rootBundle.loadString('assets/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['sandwiches']);
}
enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final String id;
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;
  final String description;
  final bool available;

  Sandwich({
    required this.id,
    required this.type,
    required this.isFootlong,
    required this.breadType,
    required this.description,
    required this.available,
  });

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    return Sandwich(
      id: json['id'] as String,
      type: SandwichType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SandwichType.veggieDelight,
      ),
      isFootlong: json['isFootlong'] as bool? ?? true,
      breadType: BreadType.values.firstWhere(
        (e) => e.name == json['breadType'],
        orElse: () => BreadType.white,
      ),
      description: json['description'] as String? ?? '',
      available: json['available'] as bool? ?? true,
    );
  }

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }
}