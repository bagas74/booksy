import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peminjaman.dart';

/// Class ini bertanggung jawab untuk semua interaksi
/// yang berhubungan dengan data peminjaman di Supabase.
class BorrowService {
  final SupabaseClient _client = Supabase.instance.client;

  // NOTE: Di aplikasi nyata, UID akan didapat dari service otentikasi.
  // Untuk sekarang, kita tetap menggunakan hardcoded UID.
  final String _testUserId =
      '8eaf2adb-8b22-4d3e-b205-d1d595d09234'; // GANTI DENGAN UID ANDA

  /// Mengambil daftar peminjaman berdasarkan status.
  Future<List<Peminjaman>> fetchBorrows({
    required bool isCurrentlyBorrowed,
  }) async {
    try {
      dynamic query = _client
          .from('peminjaman')
          .select('*, buku(*)')
          .eq('user_id', _testUserId);

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
