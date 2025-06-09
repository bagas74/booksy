import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Product>> fetchProductsByType(String type) async {
    final response = await _client.from('buku').select().eq('type', type);
    if (response == null) {
      throw Exception('Failed to load products');
    }
    return (response as List).map((map) => Product.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Mengubah warna background Scaffold menjadi abu-abu terang
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  'Cari Buku atau Kategori',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian header sekarang akan memiliki background abu-abu
              Padding(
                padding: const EdgeInsets.all(16.0),
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

              // Bagian daftar buku
              _buildProductSection(
                context: context,
                title: 'Trending',
                fetcher: fetchProductsByType('trending'),
              ),
              const SizedBox(height: 25),
              _buildProductSection(
                context: context,
                title: 'Terbaru',
                fetcher: fetchProductsByType('new'),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Product>>(
          future: fetcher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 350, // Sesuaikan tinggi dengan kartu baru
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 350,
                child: Center(
                  child: Text('Gagal memuat data: ${snapshot.error}'),
                ),
              );
            }

            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const SizedBox(
                height: 350,
                child: Center(child: Text('Tidak ada buku.')),
              );
            }

            return SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // Beri padding kiri agar kartu pertama tidak menempel
                padding: const EdgeInsets.only(left: 16),
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
