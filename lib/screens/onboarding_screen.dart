// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:booksy/models/onboarding_item.dart';
import 'home_screen.dart';
import 'onboarding_page_content.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      imagePath: 'assets/images/onboarding_1.png',
      title: 'Selamat Datang di Booksy!',
      description:
          'Temukan dan pinjam buku favoritmu dengan mudah. Jelajahi berbagai genre dan penulis.',
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding_2.png',
      title: 'Peminjaman Praktis',
      description:
          'Pinjam buku kapan saja, di mana saja. Catat semua peminjaman dan pengembalianmu.',
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding_3.png',
      title: 'Kelola Koleksimu',
      description:
          'Tambahkan buku baru ke koleksi, update status, dan buat daftar bacaanmu sendiri.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _skipOnboarding() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.animateToPage(
        _onboardingItems.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah warna latar belakang menjadi biru cerah
      backgroundColor: const Color.fromRGBO(126, 87, 194, 1),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingItems.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final item = _onboardingItems[index];
              // OnboardingPageContent tidak perlu diubah background colornya
              // karena dia akan punya Container putih di bagian bawah
              return OnboardingPageContent(item: item);
            },
          ),
          // Tombol "Lewati"
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _skipOnboarding,
              child: const Text(
                'Lewati',
                style: TextStyle(
                  color:
                      Colors
                          .white, // Tetap putih agar terlihat di latar belakang biru
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Indikator halaman (dots)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.42,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingItems.length,
                (index) => _buildDot(index, context),
              ),
            ),
          ),
          // Tombol navigasi
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child:
                _currentPage == _onboardingItems.length - 1
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color.fromRGBO(
                                127,
                                87,
                                194,
                                1,
                              ), // Warna teks tombol dibuat biru
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Buat Akun',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                127,
                                87,
                                194,
                                1,
                              ), // Warna tombol dibuat biru
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            127,
                            87,
                            194,
                            1,
                          ), // Warna tombol dibuat biru
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Selanjutnya',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color:
            _currentPage == index
                ? Colors
                    .white // Dot aktif putih di latar belakang biru
                : Colors.white54, // Dot tidak aktif sedikit transparan putih
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
