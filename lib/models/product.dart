class Product {
  final String name;
  final String author;
  final String kategori;
  final String genre;
  final String description;
  final String image;

  Product({
    required this.name,
    required this.author,
    required this.kategori,
    required this.genre,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      author: json['author'],
      kategori: json['kategori'],
      genre: json['genre'],
      description: json['description'],
      image: json['image'], // Ini hanya path dari storage Supabase
    );
  }
}
