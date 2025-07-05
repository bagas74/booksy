// lib/admin/screens/admin_manage_books_screen.dart

import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/admin_service.dart';
import '../../config/config.dart';
import 'admin_add_book_screen.dart';
import 'admin_book_detail_screen.dart';

class AdminManageBooksScreen extends StatefulWidget {
  const AdminManageBooksScreen({super.key});

  @override
  State<AdminManageBooksScreen> createState() => _AdminManageBooksScreenState();
}

class _AdminManageBooksScreenState extends State<AdminManageBooksScreen> {
  final AdminService _adminService = AdminService();
  late Future<List<Product>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = _adminService.fetchAllBooks();
    });
  }

  // Fungsi toggle status tetap ada jika Anda ingin menggunakannya di halaman detail nanti
  Future<void> _toggleStatus(
    Product book,
    String column,
    bool currentValue,
  ) async {
    try {
      await _adminService.updateBookStatus(
        bookId: book.id,
        columnName: column,
        newStatus: !currentValue,
      );
      _loadBooks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Buku'),
        // 1. Tombol Refresh ditambahkan di sini
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Daftar',
            onPressed: _loadBooks,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada buku di database.'));
          }

          final books = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                // Kolom Aksi dihapus untuk tampilan yang lebih bersih
                columns: const [
                  DataColumn(label: Text('Judul Buku')),
                  DataColumn(label: Text('Penulis')),
                  DataColumn(label: Text('Rekomendasi')),
                  DataColumn(label: Text('Populer')),
                ],
                rows:
                    books.map((book) {
                      return DataRow(
                        // 2. onSelectChanged dihapus untuk menghilangkan checkbox
                        cells: [
                          // 3. Navigasi dipindahkan ke onTap pada DataCell Judul
                          DataCell(
                            Text(book.judul),
                            onTap: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AdminBookDetailScreen(book: book),
                                ),
                              );
                              if (result == true) {
                                _loadBooks();
                              }
                            },
                          ),
                          DataCell(Text(book.penulis)),
                          DataCell(
                            Switch(
                              value: book.isRekomendasi,
                              onChanged:
                                  (value) => _toggleStatus(
                                    book,
                                    'is_rekomendasi',
                                    book.isRekomendasi,
                                  ),
                              activeColor: AppColors.primary,
                            ),
                          ),
                          DataCell(
                            Switch(
                              value: book.isPopuler ?? false,
                              onChanged:
                                  (value) => _toggleStatus(
                                    book,
                                    'is_populer',
                                    book.isPopuler ?? false,
                                  ),
                              activeColor: AppColors.primary,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AdminAddBookScreen()),
          );
          if (result == true) {
            _loadBooks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
