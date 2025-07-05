// lib/admin/screens/admin_book_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/config.dart';
import '../../models/product.dart';
import '../../services/admin_service.dart';
import 'admin_edit_book_screen.dart';

class AdminBookDetailScreen extends StatefulWidget {
  final Product book;
  const AdminBookDetailScreen({super.key, required this.book});

  @override
  State<AdminBookDetailScreen> createState() => _AdminBookDetailScreenState();
}

class _AdminBookDetailScreenState extends State<AdminBookDetailScreen> {
  // --- State baru untuk menampung data buku yang bisa di-update ---
  late Product _currentBook;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dengan data awal
    _currentBook = widget.book;
  }

  Future<void> _deleteBook() async {
    final bool didRequestDelete =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasi Hapus'),
              content: Text(
                'Apakah Anda yakin ingin menghapus buku "${_currentBook.judul}"?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (didRequestDelete && mounted) {
      try {
        await _adminService.deleteBook(
          bookId: _currentBook.id,
          imageUrl: _currentBook.image,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dihapus.'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus buku: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: _currentBook.image,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.error, size: 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentBook.judul,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'oleh ${_currentBook.penulis}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildCategoryChips(_currentBook.kategori),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Detail Informasi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Penerbit', _currentBook.penerbit),
            _buildDetailRow(
              'Tanggal Rilis',
              DateFormat('d MMMM yyyy').format(_currentBook.tanggalRilis!),
            ),
            _buildDetailRow('Bahasa', _currentBook.bahasa),
            _buildDetailRow('Format', _currentBook.format),
            _buildDetailRow(
              'Jumlah Halaman',
              '${_currentBook.halaman} halaman',
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () async {
                      // --- PERBAIKAN LOGIKA NAVIGASI & REFRESH ---
                      final updatedBook = await Navigator.push<Product>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AdminEditBookScreen(book: _currentBook),
                        ),
                      );

                      // Jika halaman edit mengembalikan data buku yang baru,
                      // perbarui state dan UI halaman detail ini.
                      if (updatedBook != null) {
                        setState(() {
                          _currentBook = updatedBook;
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                    onPressed: _deleteBook,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children:
              categories.map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
