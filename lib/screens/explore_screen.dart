import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart'; // -> Import file daftar nama kategori
import 'search_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  'Cari Buku atau Kategori',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      // Menggunakan SingleChildScrollView agar bisa di-scroll jika konten banyak
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Telusuri Kategori',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Widget Wrap akan menyusun Chip secara otomatis
            Wrap(
              spacing: 8.0, // Jarak horizontal antar chip
              runSpacing: 8.0, // Jarak vertikal antar baris chip
              children:
                  exploreCategoryNames.map((name) {
                    // Mengubah setiap nama kategori menjadi widget Chip
                    return ActionChip(
                      label: Text(name),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      backgroundColor: Colors.white,
                      // Beri border agar terlihat rapi di background abu-abu
                      side: BorderSide(color: Colors.grey.shade300),
                      onPressed: () {
                        // Aksi saat chip diklik, misalnya navigasi ke halaman kategori
                        print('Kategori "$name" diklik.');
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryResultScreen(category: name)));
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            // Anda bisa menambahkan section lain di sini jika perlu
            // const Text(
            //   'Rekomendasi Penulis',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
