import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../widgets/bottom_nav_bar.dart';
import 'product_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Product>> fetchProductsByType(String type) async {
    final response = await _client.from('buku').select().eq('type', type);

    return (response as List).map((map) => Product.fromJson(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "\u{1F4DA} Selamat Membaca di booksy",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.notifications_none),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Buku',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/banner.jpg'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Trending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// FutureBuilder untuk Trending
              FutureBuilder<List<Product>>(
                future: fetchProductsByType('trending'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 280,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Gagal memuat data trending');
                  }

                  final products = snapshot.data ?? [];
                  return SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children:
                          products.map((p) => productCard(context, p)).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Terbaru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// FutureBuilder untuk New
              FutureBuilder<List<Product>>(
                future: fetchProductsByType('new'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 340,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Gagal memuat data terbaru');
                  }

                  final products = snapshot.data ?? [];
                  return SizedBox(
                    height: 340,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children:
                          products.map((p) => productCard(context, p)).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan kartu produk
  Widget productCard(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetail(product: product),
              ),
            );
          },
          child: Container(
            width: 140,
            height: 203,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.kategori,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.penulis,
                style: const TextStyle(fontSize: 12, color: Colors.black38),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
