import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'dart:ui';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                // Gambar blur background
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Image.network(
                      product.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),

                // Lapisan overlay putih semi transparan
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.6)),
                ),

                // Gambar buku utama (atas tengah)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Image.network(
                      product.image,
                      height: 200,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Judul buku
            Center(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Kategori
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(product.kategori),
            ),

            const SizedBox(height: 16),

            // Rating dummy
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  ...List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.star, color: Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 8),
                  const Text('5', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Penulis
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text(
                    'Author',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  Text(product.author),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Genre
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text(
                    'Genre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  Text(product.genre),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Deskripsi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol pinjam
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Aksi pinjam
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4ED5),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Pinjam",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
