// lib/services/settings_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsService {
  final _supabase = Supabase.instance.client;

  /// Mengambil URL logo dari tabel 'app_settings'.
  Future<String> getLogoUrl() async {
    try {
      final response =
          await _supabase
              .from('app_settings') // Nama tabel
              .select('setting_value') // Kolom yang berisi URL
              .eq('setting_name', 'app_logo_url') // Kunci untuk logo
              .single();

      // Mengembalikan URL jika ada, atau string kosong jika tidak ditemukan
      return response['setting_value'] as String? ?? '';
    } catch (e) {
      // Menggunakan debugPrint agar hanya muncul saat debugging
      debugPrint('Error fetching logo URL: $e');
      // Kembalikan string kosong jika terjadi error
      return '';
    }
  }

  // Nanti jika ada pengaturan lain, Anda bisa tambahkan fungsinya di sini
  // Future<String> getWelcomeMessage() async { ... }
}
