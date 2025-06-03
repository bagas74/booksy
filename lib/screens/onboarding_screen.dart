// lib/screens/onboarding_screen.dart

import 'package:booksy/models/onboarding_item.dart';
import 'package:booksy/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:booksy/screens/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data untuk halaman-halaman onboarding menggunakan model
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigasi ke HomeScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
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
              return OnboardingPageContent(item: item); // Gunakan widget konten yang reusable
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
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Indikator halaman (dots)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.35,
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
            child: _currentPage == _onboardingItems.length - 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti ke RegisterScreen()
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueGrey[900],
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
                              MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti ke LoginScreen()
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[700],
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
                        backgroundColor: Colors.blueGrey[700],
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
        color: _currentPage == index ? Colors.blueGrey[700] : Colors.white54,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}