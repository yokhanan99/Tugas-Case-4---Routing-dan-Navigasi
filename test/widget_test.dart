import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_bookstore/main.dart';
import 'package:nusa_bookstore/models/book.dart';
import 'package:nusa_bookstore/providers/cart_provider.dart';
import 'package:nusa_bookstore/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('CartProvider', () {
    test('addItem menambah buku baru dan menambah jumlah jika sudah ada', () {
      final cart = CartProvider();
      cart.addItem(sampleBooks[0]);
      cart.addItem(sampleBooks[0]);
      cart.addItem(sampleBooks[1]);

      expect(cart.items.length, 2);
      expect(cart.totalItems, 3);
      expect(cart.totalPrice,
          sampleBooks[0].price * 2 + sampleBooks[1].price);
    });

    test('removeItem mengurangi jumlah lalu menghapus jika habis', () {
      final cart = CartProvider();
      cart.addItem(sampleBooks[0]);
      cart.addItem(sampleBooks[0]);

      cart.removeItem(sampleBooks[0]);
      expect(cart.totalItems, 1);

      cart.removeItem(sampleBooks[0]);
      expect(cart.isEmpty, isTrue);
    });

    test('clearCart mengosongkan keranjang dan memanggil notifyListeners', () {
      final cart = CartProvider();
      cart.addItem(sampleBooks[0]);
      var notified = 0;
      cart.addListener(() => notified++);

      cart.clearCart();

      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0);
      expect(notified, 1);
    });
  });

  test('ThemeProvider.toggleTheme mengganti light/dark', () {
    final theme = ThemeProvider();
    expect(theme.themeMode, ThemeMode.light);
    theme.toggleTheme();
    expect(theme.themeMode, ThemeMode.dark);
  });

  test('formatRupiah memakai titik pemisah ribuan', () {
    expect(formatRupiah(85000), 'Rp 85.000');
    expect(formatRupiah(1250000), 'Rp 1.250.000');
    expect(formatRupiah(0), 'Rp 0');
  });

  testWidgets('menambah buku membuat badge keranjang bertambah',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const NusaBookstoreApp(),
      ),
    );

    expect(find.text('1'), findsNothing);

    await tester.tap(find.text('Tambah ke Keranjang').first);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
