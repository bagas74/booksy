import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import '../config/config.dart';

// Diubah menjadi StatefulWidget untuk bisa mengambil dan menampilkan data dinamis
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Buat instance dari service dan siapkan Future untuk menampung data
  final ProductService _productService = ProductService();
  late Future<List<Product>> _recommendedBooksFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data rekomendasi saat halaman pertama kali dibuka
    _recommendedBooksFuture = _productService.fetchRecommendedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                const Text(
                  'Cari Buku atau Kategori',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Gunakan SingleChildScrollView agar seluruh konten bisa di-scroll
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PERUBAHAN URUTAN DI SINI ---

            // 1. SECTION KATEGORI (sekarang di atas)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Telusuri Kategori',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0, // Jarak horizontal antar chip
                runSpacing: 8.0, // Jarak vertikal antar baris chip
                children:
                    exploreCategoryNames.map((name) {
                      return ActionChip(
                        label: Text(name),
                        labelStyle: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.border),
                        onPressed: () {
                          // TODO: Aksi saat kategori diklik
                          print('Kategori "$name" diklik.');
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // 2. SECTION REKOMENDASI (sekarang di bawah)
            _buildRelatedSection(
              title: 'Rekomendasi Untukmu',
              future: _recommendedBooksFuture,
            ),

            const SizedBox(height: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Product>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 240, // Tinggi konsisten saat loading
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 240,
                child: Center(child: Text(snapshot.error.toString())),
              );
            }
            final books = snapshot.data ?? [];
            if (books.isEmpty) {
              // Jika tidak ada rekomendasi, sembunyikan section ini
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: books[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
