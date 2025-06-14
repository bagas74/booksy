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

  /// Mengambil data produk dari Supabase.
  /// Sekarang dengan penanganan error yang lebih baik.
  Future<List<Product>> fetchProductsByType(String type) async {
    try {
      // Untuk buku populer, urutkan berdasarkan 'jumlah_dibaca'
      if (type == 'trending') {
        final response = await _client
            .from('buku')
            .select()
            .order('jumlah_dibaca', ascending: false)
            .limit(10);
        return (response as List).map((map) => Product.fromJson(map)).toList();
      }
      // Untuk buku terbaru, urutkan berdasarkan 'created_at'
      if (type == 'new') {
        final response = await _client
            .from('buku')
            .select()
            .order('created_at', ascending: false)
            .limit(10);
        return (response as List).map((map) => Product.fromJson(map)).toList();
      }
      return [];
    } on PostgrestException catch (error) {
      // Menangkap error spesifik dari Supabase untuk pesan yang lebih jelas
      debugPrint('Supabase Error: ${error.message}');
      throw Exception('Gagal memuat data: ${error.message}');
    } catch (error) {
      // Menangkap error umum lainnya
      debugPrint('Generic Error: $error');
      throw Exception('Terjadi kesalahan tidak diketahui.');
    }
  }

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
              print('Tombol notifikasi ditekan!');
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
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/banner.jpg'),
                  ),
                ],
              ),
            ),

            _buildProductSection(
              context: context,
              title: 'Buku Terpopuler',
              fetcher: fetchProductsByType('trending'),
            ),

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
                // Sekarang menampilkan pesan error yang lebih spesifik
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
