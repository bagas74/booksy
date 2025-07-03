class Kategori {
  final int id;
  final String nama;

  Kategori({required this.id, required this.nama});

  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(id: map['id'] as int, nama: map['nama'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama};
  }
}
