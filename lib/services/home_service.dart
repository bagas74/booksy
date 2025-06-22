import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/banner_model.dart';

/// Class ini bertanggung jawab untuk semua logika pengambilan
/// data yang spesifik untuk HomeScreen.
class HomeService {
  final SupabaseClient _client = Supabase.instance.client;
  final _supabase = Supabase.instance.client;

  // ... (Method fetchPopularBooks dan fetchNewestBooks Anda yang sudah ada) ...

  // Method baru untuk mengambil data banner
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await _supabase
          .from('banners')
          .select()
          .eq('is_active', true) // Hanya ambil banner yang aktif
          .order(
            'order_number',
            ascending: true,
          ); // Urutkan berdasarkan order_number

      final banners =
          response
              .map<BannerModel>((data) => BannerModel.fromMap(data))
              .toList();

      return banners;
    } catch (e) {
      throw 'Gagal memuat data banner: $e';
    }
  }

  /// Mengambil daftar buku yang ditandai sebagai 'populer'.
  Future<List<Product>> fetchPopularBooks() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('is_populer', true) // <-- Menggunakan kolom boolean baru
          .limit(10);
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } on PostgrestException catch (error) {
      debugPrint('Supabase Error (Popular): ${error.message}');
      throw Exception('Gagal memuat Buku Terpopuler.');
    } catch (error) {
      throw Exception('Terjadi kesalahan tidak diketahui.');
    }
  }

  /// Mengambil daftar buku yang paling baru dirilis.
  Future<List<Product>> fetchNewestBooks() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .order('created_at', ascending: false)
          .limit(5);
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } on PostgrestException catch (error) {
      debugPrint('Supabase Error (Newest): ${error.message}');
      throw Exception('Gagal memuat Buku Terbaru.');
    } catch (error) {
      throw Exception('Terjadi kesalahan tidak diketahui.');
    }
  }
}
