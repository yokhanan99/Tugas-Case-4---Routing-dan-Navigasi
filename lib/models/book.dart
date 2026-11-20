import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final int price; // dalam Rupiah

  /// Ikon placeholder sebagai pengganti gambar sampul.
  final IconData icon;
  final Color color;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.icon,
    required this.color,
  });
}

/// Mengubah angka menjadi format Rupiah, contoh: 85000 -> "Rp 85.000".
String formatRupiah(int value) {
  final digits = value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
      );
  return 'Rp $digits';
}

/// Data contoh katalog buku.
const List<Book> sampleBooks = [
  Book(
    id: 'b1',
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 85000,
    icon: Icons.auto_stories,
    color: Colors.orange,
  ),
  Book(
    id: 'b2',
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    price: 110000,
    icon: Icons.menu_book,
    color: Colors.brown,
  ),
  Book(
    id: 'b3',
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 98000,
    icon: Icons.psychology,
    color: Colors.teal,
  ),
  Book(
    id: 'b4',
    title: 'Belajar Flutter untuk Pemula',
    author: 'Tim NusaCode',
    price: 125000,
    icon: Icons.code,
    color: Colors.blue,
  ),
  Book(
    id: 'b5',
    title: 'Sapiens: Sejarah Singkat Umat Manusia',
    author: 'Yuval Noah Harari',
    price: 140000,
    icon: Icons.history_edu,
    color: Colors.deepPurple,
  ),
  Book(
    id: 'b6',
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 105000,
    icon: Icons.bolt,
    color: Colors.green,
  ),
];
