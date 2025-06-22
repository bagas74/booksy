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
    setState(() {
      _booksFuture = _adminService.fetchAllBooks();
    });
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
      // Panggil _loadBooks untuk me-refresh data dari server
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
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                columns: const [
                  DataColumn(label: Text('Judul Buku')),
                  DataColumn(label: Text('Penulis')),
                  DataColumn(label: Text('Rekomendasi')),
                  DataColumn(label: Text('Populer')),
                  DataColumn(label: Text('Aksi')),
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
                            // --- PERBAIKAN DI SINI ---
                            // Menggunakan nilai dari model yang sudah diperbarui
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
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    // TODO: Navigasi ke halaman edit buku
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () {
                                    // TODO: Tambahkan dialog konfirmasi dan logika hapus
                                  },
                                ),
                              ],
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
