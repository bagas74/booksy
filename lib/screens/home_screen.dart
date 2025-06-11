import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import '../config/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mengambil data produk dari Supabase berdasarkan tipe ('trending' atau 'new').
  /// Sudah menggunakan try-catch untuk penanganan error yang benar.
  Future<List<Product>> fetchProductsByType(String type) async {
    try {
      final response = await _client.from('buku').select().eq('type', type);
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      // Menangkap error jika terjadi (misal: masalah jaringan atau query)
      // dan melempar exception baru agar bisa ditangani di FutureBuilder.
      debugPrint('Error fetching products: $error');
      throw Exception('Gagal memuat data dari server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Latar belakang abu-abu
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      // Menerapkan AppBar untuk Search Bar yang konsisten
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70, // Memberi ruang lebih untuk search bar
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian header (tanpa search bar, karena sudah di AppBar)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "\u{1F4DA} Selamat Membaca di booksy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(Icons.notifications_none),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/banner.jpg'),
                  ),
                ],
              ),
            ),

            // Bagian daftar buku "Trending"
            _buildProductSection(
              context: context,
              title: 'Buku Terpopuler',
              fetcher: fetchProductsByType('trending'),
            ),

            // Bagian daftar buku "Terbaru"
            _buildProductSection(
              context: context,
              title: 'Buku Baru Dirilis',
              fetcher: fetchProductsByType('new'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membuat section (Trending, Terbaru, dll)
  /// agar kode di dalam build method lebih bersih.
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
                child: Center(child: Text('Gagal memuat data')),
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
                  // Menggunakan ProductCard dari file terpisah
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
