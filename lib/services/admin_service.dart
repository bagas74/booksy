// lib/services/admin_service.dart

import 'dart:typed_data'; // Import untuk Uint8List
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class AdminService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mengambil jumlah total buku dari tabel 'buku'.
  Future<int> getTotalBooksCount() async {
    try {
      // CARA BARU yang lebih sederhana
      final count = await _client.from('buku').count();
      return count;
    } catch (e) {
      debugPrint('Error getting total books count: $e');
      return 0;
    }
  }

  /// Mengambil jumlah total pengguna.
  Future<int> getTotalUsersCount() async {
    try {
      // 'profiles' adalah tabel default untuk user di Supabase
      final count = await _client.from('profiles').count();
      return count;
    } catch (e) {
      debugPrint('Error getting total users count: $e');
      return 0;
    }
  }

  /// Mengambil SEMUA buku dari database.
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

  Future<void> updateBookStatus({
    required String bookId,
    required String columnName,
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

  /// Menambahkan buku baru ke database.
  Future<void> addBook({required Map<String, dynamic> bookData}) async {
    try {
      await _client.from('buku').insert(bookData);
    } on PostgrestException catch (e) {
      debugPrint('Supabase error adding book: ${e.message}');
      throw Exception('Gagal menambahkan buku baru.');
    }
  }

  /// Memperbarui data buku yang sudah ada berdasarkan ID.
  Future<void> updateBook({
    required String bookId,
    required Map<String, dynamic> bookData,
  }) async {
    try {
      await _client.from('buku').update(bookData).eq('id', bookId);
    } on PostgrestException catch (e) {
      debugPrint('Supabase error updating book: ${e.message}');
      throw Exception('Gagal memperbarui buku.');
    }
  }

  /// Mengupload data bytes (gambar) dan mengembalikan URL publiknya.
  Future<String> uploadFileAsBytes({
    required Uint8List bytes,
    required String fileExtension,
    required String bucketName,
    // --- PARAMETER YANG HILANG DITAMBAHKAN KEMBALI ---
    bool isUpdate = false,
    String? oldImageUrl,
  }) async {
    try {
      // Logika untuk menghapus file lama jika ini adalah proses update
      if (isUpdate && oldImageUrl != null) {
        try {
          final oldFileName = Uri.parse(oldImageUrl).pathSegments.last;
          await _client.storage.from(bucketName).remove([oldFileName]);
        } catch (e) {
          debugPrint("Gagal menghapus file lama, mungkin sudah tidak ada: $e");
        }
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      await _client.storage
          .from(bucketName)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: false),
          );

      // Untuk gambar, kembalikan URL lengkap
      if (bucketName == 'images' || bucketName == 'files') {
        return _client.storage.from(bucketName).getPublicUrl(fileName);
      }

      // Untuk file buku, kembalikan nama filenya saja
      return fileName;
    } on StorageException catch (e) {
      debugPrint('Error uploading file: $e');
      throw Exception('Gagal mengupload file.');
    }
  }

  Future<void> deleteBook({
    required String bookId,
    required String? imageUrl, // URL gambar untuk dihapus dari storage
  }) async {
    try {
      // 1. Hapus gambar dari Supabase Storage terlebih dahulu (jika ada)
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final oldFileName = Uri.parse(imageUrl).pathSegments.last;
          await _client.storage.from('images').remove([oldFileName]);
        } catch (e) {
          // Abaikan error jika file tidak ditemukan, mungkin sudah terhapus
          debugPrint(
            "Gagal menghapus file gambar lama, mungkin sudah tidak ada: $e",
          );
        }
      }

      // 2. Hapus data buku dari tabel 'buku' di database
      await _client.from('buku').delete().eq('id', bookId);
    } on PostgrestException catch (e) {
      debugPrint('Supabase error deleting book: ${e.message}');
      throw Exception('Gagal menghapus buku.');
    }
  }
}
