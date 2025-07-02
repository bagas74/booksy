class Buku {
  final int? id;
  final String judul;
  final String penulis;

  Buku({this.id, required this.judul, required this.penulis});

  // Untuk konversi dari JSON ke objek Buku
  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(id: json['id'], judul: json['judul'], penulis: json['penulis']);
  }

  // Untuk konversi dari objek Buku ke JSON
  Map<String, dynamic> toJson() {
    return {'judul': judul, 'penulis': penulis};
  }
}
