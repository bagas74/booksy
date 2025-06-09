import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final SupabaseClient _client = Supabase.instance.client;
  late final Future<List<Product>> _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchFuture = _searchProducts(widget.query);
  }

  /// Melakukan pencarian di kolom 'judul' ATAU 'penulis'
  Future<List<Product>> _searchProducts(String query) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .or('judul.ilike.%$query%,penulis.ilike.%$query%');

      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      debugPrint('Error searching products: $error');
      throw Exception('Gagal melakukan pencarian');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil untuk "${widget.query}"'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100], // Background abu-abu
      body: FutureBuilder<List<Product>>(
        future: _searchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          // State jika buku tidak ditemukan
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Buku Tidak Ditemukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coba gunakan kata kunci lain yang lebih umum.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // State jika buku ditemukan, ditampilkan dalam GridView
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Menampilkan 2 kartu per baris
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.45, // Rasio agar kartu tidak terlalu pendek
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              // Menggunakan ProductCard yang sudah ada
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
