import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 1. Menggunakan Card sebagai widget utama untuk tampilan 'kotak'
    return Card(
      // Menghilangkan shadow default agar fokus pada border
      elevation: 0,
      // Mengatur bentuk kartu: sudut tumpul dengan border abu-abu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: Colors.grey.shade300, // Warna border
          width: 1.0,
        ),
      ),
      // Memberi margin agar ada jarak antar kartu
      margin: const EdgeInsets.only(right: 16),
      // Memastikan konten di dalam card tidak keluar dari sudut tumpulnya
      clipBehavior: Clip.antiAlias,
      // Membuat seluruh area kartu bisa diklik
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetail(product: product)),
          );
        },
        child: SizedBox(
          width: 160, // Lebar kartu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Cover Buku (tanpa perubahan)
              SizedBox(
                height: 200, // Beri tinggi tetap untuk gambar
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                        ),
                      ),
                ),
              ),

              // Padding untuk semua konten teks di bawah gambar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Buku
                    Text(
                      product.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Penulis Buku
                    Text(
                      product.penulis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Informasi Halaman dan Format
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.halaman} Hal.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(), // Dorong item berikutnya ke ujung kanan
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.format,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
