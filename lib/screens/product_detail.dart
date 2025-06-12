import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../config/config.dart';
import 'library_screen.dart';
import 'reader_screen.dart'; // -> Import halaman pembaca
import '../services/product_detail_service.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ProductDetailService _service = ProductDetailService();

  bool _isAlreadyBorrowed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await _service.isBookAlreadyBorrowed(widget.product.id);
    if (mounted) {
      setState(() {
        _isAlreadyBorrowed = status;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleBorrow() async {
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Konfirmasi Peminjaman'),
            content: const Text(
              'Buku ini akan dipinjam selama 30 hari. Lanjutkan?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya, Pinjam'),
              ),
            ],
          ),
    );

    if (didConfirm == true) {
      setState(() => _isLoading = true);
      try {
        await _service.borrowBook(widget.product.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Buku berhasil dipinjam!'),
              backgroundColor: AppColors.success,
              action: SnackBarAction(
                label: 'Lihat',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LibraryScreen()),
                  );
                },
              ),
            ),
          );
          await _checkStatus();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildBlurredHeader(context),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.judul,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Kategori",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            widget.product.kategori
                                .map(
                                  (kategori) => Chip(
                                    label: Text(kategori),
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.deskripsi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Informasi Buku",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          _buildInfoTableRow("Bahasa", widget.product.bahasa),
                          _buildInfoTableRow(
                            "Tanggal Rilis",
                            widget.product.tanggalRilis == null
                                ? '-'
                                : DateFormat(
                                  'dd MMM yy',
                                ).format(widget.product.tanggalRilis!),
                          ),
                          _buildInfoTableRow(
                            "Penerbit",
                            widget.product.penerbit,
                          ),
                          _buildInfoTableRow("Penulis", widget.product.penulis),
                          _buildInfoTableRow("Halaman", widget.product.halaman),
                          _buildInfoTableRow("Format", widget.product.format),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildBorrowButton(),
                    ],
                  ),
                ),
              ],
            ),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  /// --- PERBAIKAN UTAMA ADA DI SINI ---
  /// Widget dinamis untuk menampilkan tombol
  Widget _buildBorrowButton() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // JIKA BUKU SUDAH DIPINJAM: Tampilkan tombol "Baca Buku"
    if (_isAlreadyBorrowed) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.menu_book, color: Colors.white),
        label: const Text(
          'Baca',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () {
          // Navigasi ke halaman pembaca
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReaderScreen(product: widget.product),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success, // Gunakan warna hijau
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    // JIKA BELUM DIPINJAM: Tampilkan tombol "Pinjam Buku"
    return ElevatedButton(
      onPressed: _handleBorrow,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "Pinjam Buku",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // --- Sisa Helper Widgets (tidak berubah) ---
  Widget _buildBlurredHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.network(
              widget.product.image,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(color: Colors.grey),
            ),
          ),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.network(
              widget.product.image,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      child: Material(
        color: Colors.black.withOpacity(0.3),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  TableRow _buildInfoTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(title, style: const TextStyle(color: Colors.black54)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
