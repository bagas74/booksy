// lib/screens/onboarding_screen.dart

import 'package:booksy/models/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'onboarding_page_content.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- PERUBAHAN 1: Data Lokal (Hardcoded) ---
  // Teks didefinisikan di sini karena database tidak aktif.
  // 'imageUrl' dikosongkan karena logika gambar ditangani oleh index di halaman konten.
  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Selamat Datang di Booksy!',
      description:
          'Temukan dan pinjam buku favoritmu dengan mudah. Jelajahi berbagai genre dan penulis.',
      imageUrl: 'assets/images/onboarding2.png',
    ),
    OnboardingItem(
      title: 'Peminjaman Praktis',
      description:
          'Pinjam buku kapan saja, di mana saja. Catat semua peminjaman dan pengembalianmu.',
      imageUrl: 'assets/images/onboarding3.png',
    ),
    OnboardingItem(
      title: 'Kelola Koleksimu',
      description:
          'Tambahkan buku baru ke koleksi, update status, dan buat daftar bacaanmu sendiri.',
      imageUrl: 'assets/images/onboarding4.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(126, 87, 194, 1),
      // --- PERUBAHAN 2: Hapus FutureBuilder ---
      // Langsung panggil fungsi build UI dengan data lokal
      body: buildOnboardingUI(_onboardingItems),
    );
  }

  Widget buildOnboardingUI(List<OnboardingItem> items) {
    void nextPage() {
      if (_currentPage < items.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    }

    void skipOnboarding() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: items.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            final item = items[index];
            // --- PERUBAHAN 3: Kirim parameter index ---
            // Penting agar OnboardingPageContent tahu harus memuat assets/images/onboarding(index+1).png
            return OnboardingPageContent(item: item, index: index);
          },
        ),

        // Tombol Skip (Lewati)
        Positioned(
          top: 50,
          right: 20,
          child: GestureDetector(
            onTap: skipOnboarding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Text(
                'Lewati',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Indikator Dot (Titik-titik)
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.45,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (index) => _buildDot(index, context),
            ),
          ),
        ),

        // Tombol Bawah (Login/Signup/Next)
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child:
              _currentPage == items.length - 1
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
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
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Buat Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(127, 87, 194, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 2),
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
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
