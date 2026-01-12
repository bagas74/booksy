import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mendaftarkan pengguna baru.
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        // Kita kirim metadata full_name, tapi role akan diurus otomatis oleh Trigger SQL
        data: {'full_name': fullName},
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Memproses login dan mengembalikan role dari TABEL PROFILES.
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Login ke Supabase Auth
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw Exception('Pengguna tidak ditemukan.');

      // 2. <--- PERUBAHAN PENTING: AMBIL ROLE DARI TABEL 'profiles'
      // Kita query tabel profiles berdasarkan ID user yang baru login
      final profileData =
          await _client
              .from('profiles')
              .select('role')
              .eq('id', user.id)
              .single();

      // 3. Kembalikan role (defaults to 'user' jika null)
      return profileData['role'] as String? ?? 'user';
    } on AuthException catch (e) {
      // Menangkap error salah password/email dari Supabase
      throw Exception(e.message);
    } catch (e) {
      // Menangkap error lain (misal koneksi database bermasalah)
      debugPrint("Error fetching role: $e");
      // Jika gagal ambil role, kita anggap user biasa demi keamanan, atau lempar error
      return 'user';
    }
  }

  /// Mengambil data profil dari tabel 'profiles'.
  Future<Profile> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login.');

    try {
      final response =
          await _client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (response != null) {
        return Profile.fromJson(response);
      } else {
        // Fallback jika profil belum ada (seharusnya sudah ada karena Trigger)
        // tapi tidak ada salahnya code defensive seperti ini
        final newProfileData = {
          'id': user.id,
          'email': user.email, // Pastikan email ikut disimpan
          'full_name': user.userMetadata?['full_name'] ?? 'Pengguna Baru',
        };
        final createdResponse =
            await _client
                .from('profiles')
                .insert(newProfileData)
                .select()
                .single();
        return Profile.fromJson(createdResponse);
      }
    } catch (error) {
      debugPrint("Error getProfile: $error");
      throw Exception('Gagal memuat profil pengguna.');
    }
  }

  // ... (Sisa method di bawah ini TIDAK PERLU DIUBAH, sudah benar) ...

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Gagal untuk keluar.');
    }
  }

  Future<String> uploadAvatar(Uint8List imageBytes) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login.');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${user.id}/$fileName';

    try {
      await _client.storage
          .from('avatars')
          .uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      return _client.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Gagal mengupload avatar: $e');
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? phoneNumber,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Tidak ada pengguna yang login.');

    final updates = {
      'id': user.id,
      'full_name': fullName,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'phone_number': phoneNumber,
      // Hapus 'updated_at' jika kolom tersebut belum dibuat di database
      // atau biarkan jika kamu memang punya kolom itu.
      // 'updated_at': DateTime.now().toIso8601String(),
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    try {
      await _client.from('profiles').upsert(updates);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui profil: ${e.message}');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception('Gagal mengubah kata sandi: ${e.message}');
    }
  }
}
