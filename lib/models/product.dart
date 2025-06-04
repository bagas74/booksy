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
}

final trendingProducts = [
  Product(
    name: "Fatherhood",
    author: "Marcus Berkmann",
    kategori: "Novel",
    genre: "Action, Fight, Adventure",
    description:
        "A humorous take on modern parenting. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
    image: 'assets/images/bumi1.jpg',
  ),
  Product(
    name: "Hujan",
    author: "Tere Liye",
    kategori: "Novel",
    genre: "Action, Fight, Adventure",
    description:
        "A humorous take on modern parenting. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
    image: 'assets/images/hujan2.jpg',
  ),
];

final newProducts = [
  Product(
    name: "Bumi",
    author: "Tere Liye",
    kategori: "Novel",
    genre: "Action, Fight, Adventure",
    description:
        "Petualangan remaja di dunia paralel penuh misteri. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    image: 'assets/images/bumi1.jpg',
  ),
  Product(
    name: "Fatherhood",
    author: "Marcus Berkmann",
    kategori: "Cerpen",
    genre: "Action, Fight, Adventure",
    description:
        "A humorous take on modern parenting Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    image: 'assets/images/bumi1.jpg',
  ),
  // Tambahkan produk lainnya...
];
