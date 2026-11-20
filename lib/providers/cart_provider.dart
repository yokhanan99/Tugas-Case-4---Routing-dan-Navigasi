import 'package:flutter/foundation.dart';

import '../models/book.dart';

/// Satu baris di keranjang: buku + jumlahnya.
class CartItem {
  final Book book;
  final int quantity;

  const CartItem({required this.book, required this.quantity});

  int get subtotal => book.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(book: book, quantity: quantity ?? this.quantity);
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  /// Daftar buku di keranjang.
  List<CartItem> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  /// Jumlah seluruh buku (akumulasi quantity).
  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Total harga seluruh buku.
  int get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  int quantityOf(String bookId) => _items[bookId]?.quantity ?? 0;

  /// Menambahkan buku, atau menambah jumlah jika sudah ada.
  void addItem(Book book) {
    final existing = _items[book.id];
    if (existing != null) {
      _items[book.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[book.id] = CartItem(book: book, quantity: 1);
    }
    notifyListeners();
  }

  /// Mengurangi jumlah buku; jika tinggal 1 maka dihapus dari keranjang.
  void removeItem(Book book) {
    final existing = _items[book.id];
    if (existing == null) return;
    if (existing.quantity > 1) {
      _items[book.id] = existing.copyWith(quantity: existing.quantity - 1);
    } else {
      _items.remove(book.id);
    }
    notifyListeners();
  }

  /// Mengosongkan keranjang.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
