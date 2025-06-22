class Product {
  final String id;
  final DateTime createdAt;
  final String judul;
  final String penulis;
  final List<String> kategori;
  final String deskripsi;
  final String bahasa;
  final DateTime? tanggalRilis; // Diubah menjadi DateTime dan boleh null
  final String penerbit;
  final String halaman;
  final String image;
  final String file;
  final String format;
  bool isBorrowed;
  final bool isRekomendasi;
  final bool? isPopuler;

  Product({
    required this.id,
    required this.createdAt,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.deskripsi,
    required this.image,
    required this.file,
    required this.bahasa,
    required this.halaman,
    required this.penerbit,
    this.tanggalRilis, // Tidak wajib diisi
    required this.format,
    this.isBorrowed = false,
    required this.isRekomendasi,
    required this.isPopuler,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final kategoriData = json['kategori'];
    return Product(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      judul: json['judul'] ?? '',
      penulis: json['penulis'] ?? '',
      kategori:
          kategoriData is List
              ? List<String>.from(kategoriData)
              : [], // Jika data tidak ada, kembalikan list kosong
      deskripsi: json['deskripsi'] ?? '',
      image: json['image'] ?? '',
      file: json['file'] ?? '',
      bahasa: json['bahasa'] ?? '',
      penerbit: json['penerbit'] ?? '',
      // 1. Gunakan key 'tanggal_rilis' yang benar (snake_case)
      // 2. Parse string menjadi DateTime, tangani jika datanya null
      tanggalRilis:
          json['tanggal_rilis'] == null
              ? null
              : DateTime.parse(json['tanggal_rilis']),
      halaman: json['halaman'] ?? '',
      format: json['format'] ?? '',
      isBorrowed: false,
      isRekomendasi: json['is_rekomendasi'] ?? false,
      isPopuler: json['is_populer'] ?? false,
    );
  }
}
