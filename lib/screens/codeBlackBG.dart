import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart'; // Import package intl
import '../../models/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Tentukan warna tema gelap
    const Color darkBackgroundColor = Color(0xFF1A1A1A);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Colors.grey;
    final Color chipColor = Colors.grey.shade800;

    return Scaffold(
      backgroundColor: darkBackgroundColor, // Ganti warna background
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Header dengan Gambar Latar Blur
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Container(color: Colors.grey.shade800),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Image.network(
                        product.image,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),

                // 2. Konten Detail Buku
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Buku
                      Text(
                        product.judul,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor, // Ubah warna teks
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Kategori
                      const Text(
                        "Kategori",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor, // Ubah warna teks
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          product.kategori,
                          style: const TextStyle(
                            color: primaryTextColor,
                          ), // Ubah warna teks
                        ),
                        backgroundColor: chipColor, // Ubah warna chip
                        side: BorderSide.none,
                      ),
                      const SizedBox(height: 24),

                      // Deskripsi
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor, // Ubah warna teks
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.deskripsi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor, // Ubah warna teks
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informasi Buku
                      const Text(
                        "Informasi Buku",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor, // Ubah warna teks
                        ),
                      ),
                      const SizedBox(height: 16),
                      Table(
                        // Perbaikan pada columnWidths
                        columnWidths: const {
                          5: IntrinsicColumnWidth(),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          _buildInfoTableRow(
                            "Bahasa",
                            product.bahasa,
                            secondaryTextColor,
                            primaryTextColor,
                          ),
                          _buildInfoTableRow(
                            "Tanggal Rilis",
                            // Format DateTime menjadi String yang mudah dibaca
                            product.tanggalRilis == null
                                ? '-'
                                : DateFormat(
                                  'dd MMM yyyy',
                                ).format(product.tanggalRilis!),
                            secondaryTextColor,
                            primaryTextColor,
                          ),
                          _buildInfoTableRow(
                            "Penerbit",
                            product.penerbit,
                            secondaryTextColor,
                            primaryTextColor,
                          ),
                          _buildInfoTableRow(
                            "Penulis",
                            product.penulis,
                            secondaryTextColor,
                            primaryTextColor,
                          ),
                          _buildInfoTableRow(
                            "Halaman",
                            product.halaman,
                            secondaryTextColor,
                            primaryTextColor,
                          ),
                          _buildInfoTableRow(
                            "Format",
                            product.format,
                            secondaryTextColor,
                            primaryTextColor,
                          ),
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
                            103,
                            51,
                            201,
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
            Positioned(
              top: 40,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Ubah warna container tombol kembali
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget diubah untuk menerima warna
  TableRow _buildInfoTableRow(
    String title,
    String value,
    Color titleColor,
    Color valueColor,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(title, style: TextStyle(color: titleColor)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
