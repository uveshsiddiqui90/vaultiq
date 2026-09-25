import 'package:flutter/material.dart';
import 'package:vaultiq/constant/color_constant.dart';

/// Shared category → colour / icon / label mapping.
///
/// Categories are rendered as a tinted circle plus a pill chip on several
/// screens, so the mapping lives in one place instead of being duplicated.
class CategoryHelper {
  CategoryHelper._();

  /// Every category the Add Expense form offers.
  static const List<String> categories = [
    'Groceries',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
  ];

  static const Color _healthColor = Color(0xFF06B6D4);

  /// Accent colour for [category], used for the icon and the chip text.
  static Color color(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return ColorConstant.primary;
      case 'transport':
        return ColorConstant.blue;
      case 'food':
        return ColorConstant.amber;
      case 'shopping':
        return ColorConstant.purple;
      case 'bills':
        return ColorConstant.red;
      case 'health':
        return _healthColor;
      default:
        return ColorConstant.inkMuted;
    }
  }

  /// Tinted background used behind the category icon and inside the chip.
  static Color softColor(String category) =>
      color(category).withValues(alpha: 0.14);

  static IconData icon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return Icons.shopping_cart_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'health':
        return Icons.favorite_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  /// Human readable label shown on the chip (e.g. `food` → `Food & Dining`).
  static String displayName(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'Food & Dining';
      case 'others':
        return 'Others';
      default:
        return category;
    }
  }
}
