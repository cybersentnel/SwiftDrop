import 'package:flutter_mekitakizi/core/constants/app_constants.dart';

class CartController {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + (item.item.price * item.quantity).toInt());
  void addItem(MenuItem item) {
    final index = _items.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
  }

  void removeItem(MenuItem item) {
    final index = _items.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      _items[index].quantity--;
      if (_items[index].quantity == 0) {
        _items.removeAt(index);
      }
    }
  }

  void deleteItem(MenuItem item) {
    _items.removeWhere((c) => c.item.id == item.id);
  }

  void clearCart() {
    _items.clear();
  }

  int getQuantity(String itemId) {
    final found = _items.where((c) => c.item.id == itemId);
    return found.isEmpty ? 0 : found.first.quantity;
  }

  bool get isEmpty => _items.isEmpty;
}
