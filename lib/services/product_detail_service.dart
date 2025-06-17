import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductDetailService {
  final SupabaseClient _client = Supabase.instance.client;

  final String _testUserId = '8eaf2adb-8b22-4d3e-b205-d1d595d09234'; // UID Anda

  Future<bool> isBookAlreadyBorrowed(String bookId) async {
    try {
      final response = await _client
          .from('peminjaman')
          .select()
          .eq('user_id', _testUserId)
          .eq('buku_id', bookId)
          .filter('tanggal_kembali', 'is', null);

      return (response as List).isNotEmpty;
    } catch (error) {
      debugPrint("Error checking borrow status: $error");
      return false;
    }
  }

  Future<void> borrowBook(String bookId) async {
    try {
      await _client.from('peminjaman').insert({
        'user_id': _testUserId,
        'buku_id': bookId,
        'tanggal_pinjam': DateTime.now().toIso8601String(),
        'batas_waktu':
            DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      });
    } on PostgrestException catch (error) {
      debugPrint('Supabase Error: ${error.message}');
      throw Exception('Gagal meminjam: ${error.message}');
    } catch (error) {
      debugPrint('Generic Error: $error');
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  /// Mengambil buku yang direkomendasikan
  Future<List<Product>> fetchRecommendedBooks({
    required String currentBookId,
  }) async {
    try {
      // --- PERBAIKAN URUTAN QUERY DI SINI ---
      final response = await _client
          .from('buku')
          .select()
          .eq('is_rekomendasi', true)
          .not('id', 'eq', currentBookId) // Filter dulu
          .limit(5); // Baru limit
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      debugPrint('Error fetching recommended books: $error');
      return [];
    }
  }

  /// Mengambil buku yang paling baru ditambahkan
  Future<List<Product>> fetchNewestBooks({
    required String currentBookId,
  }) async {
    try {
      // --- PERBAIKAN URUTAN QUERY DI SINI ---
      final response = await _client
          .from('buku')
          .select()
          .not('id', 'eq', currentBookId) // Filter dulu
          .order('created_at', ascending: false) // Baru diurutkan
          .limit(5); // Terakhir di-limit
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      debugPrint('Error fetching newest books: $error');
      return [];
    }
  }
}
