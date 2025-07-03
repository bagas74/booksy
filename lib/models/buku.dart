class Buku {
  final int id;
  final String judul;
  final String penulis;
  final int kategoriId;
  final String kategoriNama;

  Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.kategoriId,
    required this.kategoriNama,
  });

  factory Buku.fromMap(Map<String, dynamic> map) {
    return Buku(
      id: map['id'] as int,
      judul: map['judul'] as String,
      penulis: map['penulis'] as String,
      kategoriId: map['kategori_id'] as int,
      kategoriNama:
          map['kategori']['nama'] ?? '-', // Ambil dari relasi kategori
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'penulis': penulis,
      'kategori_id': kategoriId,
    };
  }
}
