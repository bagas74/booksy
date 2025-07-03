import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booksy/models/kategori.dart';

class KategoriService {
  final supabase = Supabase.instance.client;

  Future<List<Kategori>> fetchKategori() async {
    final response = await supabase.from('kategori').select();
    return (response as List).map((e) => Kategori.fromMap(e)).toList();
  }

  Future<void> tambahKategori(String nama) async {
    await supabase.from('kategori').insert({'nama': nama});
  }

  Future<void> updateKategori(int id, String namaBaru) async {
    await supabase.from('kategori').update({'nama': namaBaru}).eq('id', id);
  }

  Future<void> hapusKategori(int id) async {
    await supabase.from('kategori').delete().eq('id', id);
  }
}
