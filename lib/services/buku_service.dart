// 📁 buku_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/buku.dart';
import '../models/kategori.dart';

class BukuService {
  final supabase = Supabase.instance.client;

  Future<List<Buku>> fetchBuku() async {
    final response = await supabase
        .from('bukus')
        .select('id, judul, penulis, kategori_id, kategori(kategori_nama)');
    return response.map((e) => Buku.fromMap(e)).toList();
  }

  Future<List<Kategori>> fetchKategori() async {
    final response = await supabase.from('kategori').select();
    return response.map((e) => Kategori.fromMap(e)).toList();
  }

  Future<void> tambahBuku(Buku buku) async {
    await supabase.from('bukus').insert({
      'judul': buku.judul,
      'penulis': buku.penulis,
      'kategori_id': buku.kategoriId,
    });
  }

  Future<void> deleteBuku(int id) async {
    await supabase.from('bukus').delete().match({'id': id});
  }
}
