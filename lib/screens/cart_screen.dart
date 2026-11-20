import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch: seluruh halaman dibangun ulang saat keranjang berubah.
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 72, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('Keranjang masih kosong',
                      style: theme.textTheme.titleMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) =>
                  _CartItemCard(item: cart.items[index]),
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            border: Border(top: BorderSide(color: theme.dividerColor)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Item'),
                  Text('${cart.totalItems} buku'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Pembayaran',
                      style: theme.textTheme.titleMedium),
                  Text(
                    formatRupiah(cart.totalPrice),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: cart.isEmpty ? null : () => _checkout(context),
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout / Bayar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkout(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final total = formatRupiah(cartProvider.totalPrice);
    final items = cartProvider.totalItems;

    cartProvider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout berhasil! $items buku, total $total'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = item.book;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                color: book.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(book.icon, color: book.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text('${formatRupiah(book.price)} / buku',
                      style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    'Subtotal: ${formatRupiah(item.subtotal)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Kurangi',
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      context.read<CartProvider>().removeItem(book),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${item.quantity}',
                      style: theme.textTheme.titleMedium),
                ),
                IconButton.filledTonal(
                  tooltip: 'Tambah',
                  icon: const Icon(Icons.add),
                  onPressed: () => context.read<CartProvider>().addItem(book),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
