import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailService {
  final SupabaseClient _client = Supabase.instance.client;

  final String _testUserId = '8eaf2adb-8b22-4d3e-b205-d1d595d09234'; // UID Anda

  Future<bool> isBookAlreadyBorrowed(String bookId) async {
    // ... (Fungsi ini sudah benar, tidak perlu diubah)
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

  /// --- PERBAIKAN DI SINI ---
  /// Fungsi ini sekarang secara konsisten menerima 'String bookId'
  Future<void> borrowBook(String bookId) async {
    try {
      debugPrint('--- DEBUG: MEMINJAM BUKU ---');
      debugPrint('User ID: $_testUserId');
      debugPrint('Buku ID: $bookId'); // <- Menggunakan bookId dari parameter
      debugPrint('-----------------------------');

      await _client.from('peminjaman').insert({
        'user_id': _testUserId,
        'buku_id': bookId, // <- Menggunakan bookId dari parameter
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
}
