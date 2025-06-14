import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

/// Class ini bertanggung jawab untuk semua logika pengambilan data buku.
class ProductService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mengambil semua buku yang ditandai sebagai 'rekomendasi' dari database.
  Future<List<Product>> fetchRecommendedBooks() async {
    try {
      final response = await _client
          .from('buku')
          .select() // Ambil semua kolom
          .eq('is_rekomendasi', true) // Filter HANYA yang is_rekomendasi = true
          .limit(10); // Batasi hasilnya agar tidak terlalu banyak

      return (response as List).map((map) => Product.fromJson(map)).toList();
    } on PostgrestException catch (e) {
      // Menangkap error spesifik dari Supabase untuk pesan yang lebih jelas
      debugPrint('Error fetching recommended books: ${e.message}');
      throw Exception('Gagal memuat rekomendasi: ${e.message}');
    } catch (e) {
      // Menangkap error umum lainnya
      throw Exception(
        'Terjadi kesalahan yang tidak diketahui saat memuat rekomendasi.',
      );
    }
  }
}
