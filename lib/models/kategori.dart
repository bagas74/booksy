// lib/models/category.dart

class Kategori {
  final String id;
  final String nama;

  Kategori({required this.id, required this.nama});

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(id: map['id'] as String, nama: map['nama'] as String);
  }
}
