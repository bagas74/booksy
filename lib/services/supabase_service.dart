import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booksy/models/buku.dart';
import 'package:booksy/models/kategori.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ================= Buku =================
  Future<List<Buku>> fetchBuku() async {
    final response = await supabase
        .from('buku')
        .select('id, judul, penulis, kategori_id, kategori(nama)')
        .order('id', ascending: false);
    return (response as List).map((e) => Buku.fromMap(e)).toList();
  }

  Future<void> tambahBuku(String judul, String penulis, int kategoriId) async {
    await supabase.from('buku').insert({
      'judul': judul,
      'penulis': penulis,
      'kategori_id': kategoriId,
    });
  }

  Future<void> hapusBuku(int id) async {
    await supabase.from('buku').delete().eq('id', id);
  }

  // ================= Kategori =================
  Future<List<Kategori>> fetchKategori() async {
    final response = await supabase.from('kategori').select();
    return (response as List).map((e) => Kategori.fromMap(e)).toList();
  }

  Future<void> tambahKategori(String nama) async {
    await supabase.from('kategori').insert({'nama': nama});
  }

  Future<void> hapusKategori(int id) async {
    await supabase.from('kategori').delete().eq('id', id);
  }

  // ================= Pengguna =================
  Future<List<Map<String, dynamic>>> fetchPengguna() async {
    return await supabase.from('pengguna').select();
  }

  Future<void> tambahPengguna(Map<String, dynamic> data) async {
    await supabase.from('pengguna').insert(data);
  }

  Future<void> updatePengguna(int id, Map<String, dynamic> data) async {
    await supabase.from('pengguna').update(data).eq('id', id);
  }

  Future<void> hapusPengguna(int id) async {
    await supabase.from('pengguna').delete().eq('id', id);
  }

  // ================= Riwayat Peminjaman =================
  Future<List<Map<String, dynamic>>> fetchRiwayat() async {
    final response = await supabase
        .from('peminjaman')
        .select(
          'id, buku(judul), user(nama), tanggal_pinjam, tanggal_kembali, sudah_dikembalikan',
        )
        .order('tanggal_pinjam', ascending: false);
    return (response as List)
        .map(
          (e) => {
            'judul': e['buku']['judul'],
            'user': e['user']['nama'],
            'tanggal_pinjam': e['tanggal_pinjam'],
            'tanggal_kembali': e['tanggal_kembali'],
            'sudah_dikembalikan': e['sudah_dikembalikan'],
          },
        )
        .toList();
  }
}
