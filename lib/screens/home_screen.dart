import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // <-- Perlu ditambahkan
import 'package:cached_network_image/cached_network_image.dart'; // <-- Perlu ditambahkan
import '../models/product.dart';
import '../models/banner_model.dart'; // <-- Perlu ditambahkan
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import '../config/config.dart';
import '../services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();

  late Future<List<Product>> _popularBooksFuture;
  late Future<List<Product>> _newBooksFuture;
  // --- AWAL PENAMBAHAN UNTUK BANNER ---
  late Future<List<BannerModel>> _bannersFuture;
  int _currentBannerIndex = 0;
  // --- AKHIR PENAMBAHAN UNTUK BANNER ---

  @override
  void initState() {
    super.initState();
    _popularBooksFuture = _homeService.fetchPopularBooks();
    _newBooksFuture = _homeService.fetchNewestBooks();
    // --- AWAL PENAMBAHAN UNTUK BANNER ---
    _bannersFuture = _homeService.fetchBanners();
    // --- AKHIR PENAMBAHAN UNTUK BANNER ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  'Cari Buku atau Penulis',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Aksi untuk tombol notifikasi
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AWAL PERUBAHAN BAGIAN BANNER ---
            // Padding dan Column yang lama dihapus dan diganti dengan widget baru ini
            _buildBannerCarousel(),
            // --- AKHIR PERUBAHAN BAGIAN BANNER ---

            // Gunakan Future yang sudah diinisialisasi dari state
            _buildProductSection(
              context: context,
              title: 'Buku Terpopuler',
              fetcher: _popularBooksFuture,
            ),

            _buildProductSection(
              context: context,
              title: 'Buku Baru Dirilis',
              fetcher: _newBooksFuture,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- AWAL PENAMBAHAN WIDGET BARU UNTUK BANNER ---
  Widget _buildBannerCarousel() {
    return FutureBuilder<List<BannerModel>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        // State saat data sedang dimuat
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AspectRatio(
            aspectRatio: 16 / 7.5,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
        // State jika terjadi error atau tidak ada banner di database
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          // Tampilkan banner statis lokal sebagai cadangan
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(''),
            ),
          );
        }

        // State jika data berhasil dimuat
        final banners = snapshot.data!;
        return Column(
          children: [
            const SizedBox(height: 16),
            CarouselSlider.builder(
              itemCount: banners.length,
              itemBuilder: (context, index, realIndex) {
                final banner = banners[index];
                return GestureDetector(
                  onTap: () {
                    if (banner.targetUrl != null) {
                      // Logika navigasi jika banner di-klik
                      print('Banner diklik, navigasi ke: ${banner.targetUrl}');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        imageUrl: banner.imageUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) =>
                                Container(color: Colors.grey.shade300),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 7,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
              ),
            ),
            // Indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  banners.asMap().entries.map((entry) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(
                          _currentBannerIndex == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
  // --- AKHIR PENAMBAHAN WIDGET BARU UNTUK BANNER ---

  /// Helper widget untuk membuat section (Terpopuler, Terbaru, dll)
  Widget _buildProductSection({
    required BuildContext context,
    required String title,
    required Future<List<Product>> fetcher,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Product>>(
          future: fetcher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 350,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              );
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const SizedBox(
                height: 350,
                child: Center(child: Text('Tidak ada buku untuk ditampilkan.')),
              );
            }
            return SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
