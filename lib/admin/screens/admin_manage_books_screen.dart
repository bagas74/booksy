import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/admin_service.dart';
import '../../config/config.dart';

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
    _booksFuture = _adminService.fetchAllBooks();
  }

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
      // Refresh data setelah berhasil update
      setState(() {
        _loadBooks();
      });
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
      appBar: AppBar(title: const Text('Kelola Buku')),
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
                columns: const [
                  DataColumn(label: Text('Judul Buku')),
                  DataColumn(label: Text('Penulis')),
                  DataColumn(label: Text('Rekomendasi')),
                  DataColumn(label: Text('Populer')),
                ],
                rows:
                    books.map((book) {
                      return DataRow(
                        cells: [
                          DataCell(Text(book.judul)),
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
                              value:
                                  book.isPopuler ??
                                  false, // Asumsi ada kolom is_populer
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
        onPressed: () {
          // TODO: Navigasi ke halaman Tambah Buku Baru
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
