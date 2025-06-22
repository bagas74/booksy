import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductDetailService {
  final SupabaseClient _client = Supabase.instance.client;

  // Variabel _testUserId sudah tidak diperlukan lagi dan dihapus.

  /// Mengecek apakah sebuah buku sudah dipinjam oleh pengguna yang sedang login.
  Future<bool> isBookAlreadyBorrowed(String bookId) async {
    // Dapatkan pengguna yang sedang login
    final currentUser = _client.auth.currentUser;

    // Jika tidak ada pengguna, pasti buku tersebut belum dipinjam.
    if (currentUser == null) {
      return false;
    }

    try {
      final response = await _client
          .from('peminjaman')
          .select()
          .eq('user_id', currentUser.id) // Gunakan ID pengguna yang sebenarnya
          .eq('buku_id', bookId)
          .filter('tanggal_kembali', 'is', null);

      return (response as List).isNotEmpty;
    } catch (error) {
      debugPrint("Error checking borrow status: $error");
      return false;
    }
  }

  /// Memproses peminjaman buku untuk pengguna yang sedang login.
  Future<void> borrowBook(String bookId) async {
    // Dapatkan pengguna yang sedang login
    final currentUser = _client.auth.currentUser;

    // Jika tidak ada pengguna, lempar error karena tidak bisa meminjam
    if (currentUser == null) {
      throw Exception('Anda harus login untuk meminjam buku.');
    }

    try {
      await _client.from('peminjaman').insert({
        'user_id': currentUser.id, // Gunakan ID pengguna yang sebenarnya
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

  // --- Fungsi di bawah ini tidak bergantung pada user, jadi tidak berubah ---

  /// Mengambil buku yang direkomendasikan
  Future<List<Product>> fetchRecommendedBooks({
    required String currentBookId,
  }) async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .eq('is_rekomendasi', true)
          .not('id', 'eq', currentBookId)
          .limit(5);
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
      final response = await _client
          .from('buku')
          .select()
          .not('id', 'eq', currentBookId)
          .order('created_at', ascending: false)
          .limit(5);
      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      debugPrint('Error fetching newest books: $error');
      return [];
    }
  }
}
