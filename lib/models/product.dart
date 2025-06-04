class Product {
  final String name;
  final String author;
  final String genre;
  final String description;
  final String image;

  Product({
    required this.name,
    required this.author,
    required this.genre,
    required this.description,
    required this.image,
  });
}

final trendingProducts = [
  Product(
    name: "Fatherhood",
    author: "Marcus Berkmann",
    genre: "Parenting",
    description: "A humorous take on modern parenting.",
    image: 'assets/images/bumi1.jpg',
  ),
  Product(
    name: "Fatherhood",
    author: "Marcus Berkmann",
    genre: "Parenting",
    description: "A humorous take on modern parenting.",
    image: 'assets/images/bumi1.jpg',
  ),
  // Tambahkan produk lainnya...
];

final newProducts = [
  Product(
    name: "Bumi",
    author: "Tere Liye",
    genre: "Fiksi",
    description: "Petualangan remaja di dunia paralel penuh misteri.",
    image: 'assets/images/bumi1.jpg',
  ),
  Product(
    name: "Fatherhood",
    author: "Marcus Berkmann",
    genre: "Parenting",
    description: "A humorous take on modern parenting.",
    image: 'assets/images/bumi1.jpg',
  ),
  // Tambahkan produk lainnya...
];
