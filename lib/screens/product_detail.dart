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
            // Bagian gambar atas
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.6)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Image.network(
                      product.image,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
              ],
            ),

            // Container untuk bagian informasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ), // Ganti dengan warna background yang diinginkan
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                  Text(product.kategori),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('5', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Penulis',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 15),
                      Text(product.penulis),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Genre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 15),
                      Text(product.genre),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4ED5),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Pinjam",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
