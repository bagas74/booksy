import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../config/config.dart';
import 'library_screen.dart';
import 'reader_screen.dart';
import '../services/product_detail_service.dart';
import '../widgets/product_card.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Membuat instance dari service untuk mengakses logika data
  final ProductDetailService _service = ProductDetailService();

  // State untuk mengelola UI
  bool _isAlreadyBorrowed = false;
  bool _isLoading = true;

  // State untuk menampung data buku terkait
  late Future<List<Product>> _recommendedBooksFuture;
  late Future<List<Product>> _newBooksFuture;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Memuat semua data yang dibutuhkan saat halaman dibuka
  void _loadInitialData() {
    // Memanggil service untuk mengecek status buku yang sedang dilihat
    _checkStatus();
    // Memanggil service untuk mengambil daftar buku rekomendasi
    _recommendedBooksFuture = _service.fetchRecommendedBooks(
      currentBookId: widget.product.id,
    );
    // Memanggil service untuk mengambil daftar buku terbaru
    _newBooksFuture = _service.fetchNewestBooks(
      currentBookId: widget.product.id,
    );
  }

  /// Memanggil service untuk mengecek status peminjaman dan memperbarui UI
  Future<void> _checkStatus() async {
    if (!_isLoading) setState(() => _isLoading = true);

    final status = await _service.isBookAlreadyBorrowed(widget.product.id);
    if (mounted) {
      setState(() {
        _isAlreadyBorrowed = status;
        _isLoading = false;
      });
    }
  }

  /// Menangani seluruh alur peminjaman, dari dialog hingga notifikasi
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
          // Refresh status tombol setelah berhasil pinjam
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
        // Pastikan loading berhenti meskipun terjadi error
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
      bottomNavigationBar: _buildBottomActionButton(),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildBlurredHeader(context),
                Container(
                  // Menggunakan padding vertikal agar ada jarak atas dan bawah
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                      // Konten utama dengan padding horizontal
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                _buildInfoTableRow(
                                  "Bahasa",
                                  widget.product.bahasa,
                                ),
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
                                _buildInfoTableRow(
                                  "Penulis",
                                  widget.product.penulis,
                                ),
                                _buildInfoTableRow(
                                  "Halaman",
                                  widget.product.halaman,
                                ),
                                _buildInfoTableRow(
                                  "Format",
                                  widget.product.format,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      // Section untuk rekomendasi dan buku baru
                      _buildRelatedSection(
                        title: "Rekomendasi Lainnya",
                        future: _recommendedBooksFuture,
                      ),
                      const SizedBox(height: 24),
                      _buildRelatedSection(
                        title: "Buku Terbaru",
                        future: _newBooksFuture,
                      ),

                      // Padding bawah untuk memastikan konten terakhir tidak tertutup bottom bar
                      const SizedBox(height: 100),
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

  /// Helper widget untuk membangun section buku yang di-scroll horizontal
  Widget _buildRelatedSection({
    required String title,
    required Future<List<Product>> future,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Product>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const SizedBox.shrink(); // Tidak tampilkan apa-apa jika kosong/error
            }

            final products = snapshot.data!;

            // --- BAGIAN DEBUGGING ---
            // Cetak jumlah item yang sebenarnya diterima ke konsol
            debugPrint('Section "$title" menerima ${products.length} buku.');
            // -----------------------

            return SizedBox(
              height: 350, // Sesuaikan tinggi ini agar pas dengan ProductCard
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // Gunakan itemExtent untuk memberi tahu ListView lebar setiap item
                // Ini membantu performa dan stabilitas layout.
                // Sesuaikan 160 dengan lebar ProductCard Anda + margin kanannya.
                itemExtent: 160 + 16,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Helper widget untuk membangun tombol di bagian bawah layar
  Widget _buildBottomActionButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child:
          _isLoading
              ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              )
              : _isAlreadyBorrowed
              ? ElevatedButton.icon(
                icon: const Icon(Icons.menu_book, color: Colors.white),
                label: const Text(
                  'Baca Buku',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(product: widget.product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
              : ElevatedButton(
                onPressed: _handleBorrow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Pinjam Buku",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
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
