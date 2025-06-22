import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peminjaman.dart';

/// Class ini bertanggung jawab untuk semua interaksi
/// yang berhubungan dengan data peminjaman di Supabase.
class BorrowService {
  final SupabaseClient _client = Supabase.instance.client;

  // Variabel _testUserId sudah tidak diperlukan lagi dan dihapus.

  /// Mengambil daftar peminjaman berdasarkan status untuk pengguna yang sedang login.
  Future<List<Peminjaman>> fetchBorrows({
    required bool isCurrentlyBorrowed,
  }) async {
    // 1. Dapatkan pengguna yang sedang login saat ini.
    final currentUser = _client.auth.currentUser;

    // 2. Jika tidak ada pengguna yang login, kembalikan daftar kosong.
    //    Ini mencegah error dan akan menampilkan halaman kosong di UI.
    if (currentUser == null) {
      return [];
    }

    try {
      dynamic query = _client
          .from('peminjaman')
          .select('*, buku(*)')
          // 3. Gunakan ID pengguna yang sebenarnya dari currentUser.id
          .eq('user_id', currentUser.id);

      if (isCurrentlyBorrowed) {
        query = query.filter('tanggal_kembali', 'is', null);
      } else {
        query = query.not('tanggal_kembali', 'is', null);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((data) => Peminjaman.fromJson(data))
          .toList();
    } catch (error) {
      debugPrint("Error fetching borrows: $error");
      throw Exception('Gagal memuat data perpustakaan');
    }
  }

  /// Mengupdate record peminjaman untuk mengembalikan buku.
  /// Fungsi ini tidak perlu user_id, jadi tidak ada perubahan logika.
  Future<void> returnBook(String peminjamanId) async {
    try {
      await _client
          .from('peminjaman')
          .update({'tanggal_kembali': DateTime.now().toIso8601String()})
          .eq('id', peminjamanId);
    } catch (error) {
      debugPrint("Error returning book: $error");
      throw Exception('Gagal mengembalikan buku');
    }
  }
}
