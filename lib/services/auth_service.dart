import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

/// Class ini bertanggung jawab untuk semua logika otentikasi
/// seperti daftar, masuk, keluar, dan manajemen profil.
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
        data: {'full_name': fullName, 'role': 'user'},
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Memproses login dan mengembalikan role.
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
        final newProfileData = {
          'id': user.id,
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
      throw Exception('Gagal memuat atau membuat profil pengguna.');
    }
  }

  /// Mengambil objek User Supabase saat ini.
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Mengeluarkan pengguna (logout).
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Gagal untuk keluar.');
    }
  }

  /// Meng-upload gambar avatar dari bytes (untuk Web).
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

  /// Memperbarui data profil pengguna.
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
      'updated_at': DateTime.now().toIso8601String(),
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    try {
      await _client.from('profiles').upsert(updates);
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui profil: ${e.message}');
    }
  }

  /// Memperbarui kata sandi pengguna yang sedang login.
  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception('Gagal mengubah kata sandi: ${e.message}');
    }
  }
}
