import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalService {
  static const _cartKey = 'cart_items';

  // Add a course to cart
  Future<void> addToCart(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    if (!cartItems.contains(courseId)) {
      cartItems.add(courseId);
      await prefs.setStringList(_cartKey, cartItems);
    }
  }

  // Remove a course from cart
  Future<void> removeFromCart(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    cartItems.remove(courseId);
    await prefs.setStringList(_cartKey, cartItems);
  }

  // Get all cart items
  Future<List<String>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cartKey) ?? [];
  }

  // Clear all cart items
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
