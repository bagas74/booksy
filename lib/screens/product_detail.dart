import 'package:flutter/material.dart';
import 'dart:ui'; // Diperlukan lagi untuk ImageFilter.blur
import '../../models/product.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Atur background utama
      body: SafeArea(
        top: false, // SafeArea tidak berlaku untuk bagian atas
        child: Stack(
          children: [
            // Konten utama yang bisa di-scroll
            ListView(
              padding: EdgeInsets.zero, // Hapus padding default ListView
              children: [
                // 1. Header dengan Gambar Latar Blur dan Cover di Tengah
                _buildHeader(context),

                // 2. Konten Detail Buku di Bawah Gambar
                // Konten ini sekarang dibungkus Container agar punya latar putih
                // dan terpisah jelas dari header.
                Container(
                  padding: const EdgeInsets.all(20.0),
                  // Beri decoration agar bisa punya sudut tumpul di atas
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // Sudut tumpul hanya di sisi atas kiri dan kanan
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Buku
                      Text(
                        product.judul,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Kategori
                      const Text(
                        "Kategori",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Wrap untuk menampilkan banyak kategori
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            product.kategori.map((kategori) {
                              return Chip(
                                label: Text(kategori),
                                backgroundColor: Colors.grey.shade200,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Deskripsi
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.deskripsi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height:
                              1.5, // Beri jarak antar baris agar mudah dibaca
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informasi Buku
                      const Text(
                        "Informasi Buku",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tabel Informasi dengan perbaikan
                      Table(
                        // PERBAIKAN: Indeks kolom harus 0 dan 1
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          _buildInfoTableRow("Bahasa", product.bahasa),
                          _buildInfoTableRow(
                            "Tanggal Rilis",
                            product.tanggalRilis == null
                                ? '-'
                                : DateFormat(
                                  'dd MMM yyyy',
                                ).format(product.tanggalRilis!),
                          ),
                          _buildInfoTableRow("Penerbit", product.penerbit),
                          _buildInfoTableRow("Penulis", product.penulis),
                          _buildInfoTableRow("Halaman", product.halaman),
                          _buildInfoTableRow("Format", product.format),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Tombol Aksi "Pinjam"
                      ElevatedButton(
                        onPressed: () {
                          // Aksi ketika tombol pinjam ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            141,
                            18,
                            172,
                          ),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Pinjam",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tombol Kembali (Back) di atas Stack
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membangun header (dipisahkan agar lebih rapi)
  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(color: Colors.grey),
            ),
          ),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.1))),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
          ), // Beri jarak dari konten di bawah
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image.network(
              product.image,
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

  /// Helper widget untuk Tombol Kembali
  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 50, // Disesuaikan agar lebih pas dengan status bar
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.4),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }

  /// Helper widget untuk membuat baris pada tabel informasi
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
