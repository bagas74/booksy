class Product {
  final String name;
  final String author;
  final String kategori;
  final String genre;
  final String description;
  final String image;
  final String file; // tambahan
  bool isBorrowed; // status dipinjam

  Product({
    required this.name,
    required this.author,
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
      author: json['author'] ?? '',
      kategori: json['category'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      image: json['image_url'] ?? '',
      file: json['file_url'] ?? '', // Pastikan aman walau kosong/null
      isBorrowed: false, // default
    );
  }
}
