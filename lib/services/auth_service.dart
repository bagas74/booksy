import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Class ini bertanggung jawab untuk semua logika otentikasi
/// seperti daftar, masuk, dan keluar.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mendaftarkan pengguna baru dengan email dan kata sandi.
  /// Juga bisa menyimpan data tambahan seperti nama lengkap.
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          // Data ini akan disimpan di kolom 'raw_user_meta_data'
          // dan bisa digunakan untuk menampilkan nama pengguna.
          'full_name': fullName,
        },
      );
    } on AuthException catch (error) {
      // Menangkap error spesifik dari Supabase Auth
      debugPrint('Supabase Auth Error: ${error.message}');
      throw Exception(error.message);
    } catch (error) {
      // Menangkap error umum lainnya
      debugPrint('Generic SignUp Error: $error');
      throw Exception('Terjadi kesalahan saat mendaftar.');
    }
  }

  // Nanti kita akan tambahkan fungsi signIn() dan signOut() di sini.
}
