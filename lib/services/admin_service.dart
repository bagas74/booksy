import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

/// Class ini bertanggung jawab untuk semua logika
/// yang dibutuhkan oleh panel admin.
class AdminService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mengambil SEMUA buku dari database, diurutkan berdasarkan tanggal dibuat.
  Future<List<Product>> fetchAllBooks() async {
    try {
      final response = await _client
          .from('buku')
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((map) => Product.fromJson(map)).toList();
    } catch (error) {
      debugPrint('Error fetching all books: $error');
      throw Exception('Gagal memuat daftar buku.');
    }
  }

  /// Memperbarui status boolean (is_rekomendasi atau is_populer) untuk sebuah buku.
  Future<void> updateBookStatus({
    required String bookId,
    required String columnName, // 'is_rekomendasi' atau 'is_populer'
    required bool newStatus,
  }) async {
    try {
      await _client
          .from('buku')
          .update({columnName: newStatus})
          .eq('id', bookId);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui status buku: ${e.message}');
    }
  }
}
