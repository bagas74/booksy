import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

/// Class ini bertanggung jawab untuk semua logika pencarian buku.
class SearchService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Melakukan pencarian di kolom 'judul' DAN 'penulis'.
  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

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
}
