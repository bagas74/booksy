class Product {
  final String name;
  final String penulis;
  final String kategori;
  final String genre;
  final String description;
  final String image;
  final String file; // tambahan
  bool isBorrowed; // status dipinjam

  Product({
    required this.name,
    required this.penulis,
    required this.kategori,
    required this.genre,
    required this.description,
    required this.image,
    required this.file, // tambahan
    this.isBorrowed = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['title'] ?? '',
      penulis: json['penulis'] ?? '',
      kategori: json['category'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      image: json['image_url'] ?? '',
      file: json['file_url'] ?? '', // Pastikan aman walau kosong/null
      isBorrowed: false, // default
    );
  }
}
