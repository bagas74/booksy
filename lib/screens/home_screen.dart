import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import '../config/config.dart';
import '../services/home_service.dart'; // -> 1. Import service yang baru

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. Buat instance dari HomeService
  final HomeService _homeService = HomeService();

  late Future<List<Product>> _popularBooksFuture;
  late Future<List<Product>> _newBooksFuture;

  @override
  void initState() {
    super.initState();
    // 3. Panggil method dari service yang baru saat halaman dibuka
    _popularBooksFuture = _homeService.fetchPopularBooks();
    _newBooksFuture = _homeService.fetchNewestBooks();
  }

  // 4. --- FUNGSI fetchProductsByType() YANG LAMA SEKARANG DIHAPUS DARI SINI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  'Cari Buku atau Penulis',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Aksi untuk tombol notifikasi
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "\u{1F4DA} Selamat Membaca di booksy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/banner.jpg'),
                  ),
                ],
              ),
            ),

            // Gunakan Future yang sudah diinisialisasi dari state
            _buildProductSection(
              context: context,
              title: 'Buku Terpopuler',
              fetcher: _popularBooksFuture,
            ),

            _buildProductSection(
              context: context,
              title: 'Buku Baru Dirilis',
              fetcher: _newBooksFuture,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membuat section (Terpopuler, Terbaru, dll)
  Widget _buildProductSection({
    required BuildContext context,
    required String title,
    required Future<List<Product>> fetcher,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Product>>(
          future: fetcher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 350,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              );
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const SizedBox(
                height: 350,
                child: Center(child: Text('Tidak ada buku untuk ditampilkan.')),
              );
            }
            return SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
