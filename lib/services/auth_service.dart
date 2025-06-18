import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart'; // -> Pastikan model Profile di-import

/// Class ini bertanggung jawab untuk semua logika otentikasi.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mendaftarkan pengguna baru (logika tidak berubah)
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': 'user'},
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Memproses login (logika tidak berubah)
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw Exception('Pengguna tidak ditemukan.');
      return user.userMetadata?['role'] ?? 'user';
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // --- FUNGSI-FUNGSI BARU YANG DIPERLUKAN ADA DI SINI ---

  /// Mengambil data profil dari tabel 'profiles' untuk pengguna yang sedang login.
  Future<Profile> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Tidak ada pengguna yang login untuk mengambil profil.');
    }

    try {
      final response =
          await _client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single(); // .single() mengambil satu baris dan akan error jika tidak ada

      return Profile.fromJson(response);
    } catch (error) {
      throw Exception('Gagal memuat profil pengguna.');
    }
  }

  /// Mengambil objek User bawaan Supabase (untuk mendapatkan email, dll).
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Mengeluarkan pengguna dari sesi saat ini (logout).
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      debugPrint("Error signing out: $error");
      throw Exception('Gagal untuk keluar.');
    }
  }
}
