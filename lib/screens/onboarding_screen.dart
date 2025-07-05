// lib/screens/onboarding_screen.dart

import 'package:booksy/models/onboarding_item.dart';
import 'package:booksy/services/onboarding_service.dart';
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
  final OnboardingService _onboardingService = OnboardingService();
  late Future<List<OnboardingItem>> _onboardingFuture;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _onboardingFuture = _onboardingService.fetchOnboardingItems();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(126, 87, 194, 1),
      body: FutureBuilder<List<OnboardingItem>>(
        future: _onboardingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const LoginScreen();
          }

          final onboardingItems = snapshot.data!;
          return buildOnboardingUI(onboardingItems);
        },
      ),
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
            return OnboardingPageContent(item: item);
          },
        ),
        Positioned(
          top: 40,
          right: 20,
          child: GestureDetector(
            onTap: skipOnboarding,
            child: const Text(
              'Lewati',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.42,
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
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child:
              _currentPage == items.length - 1
                  // --- AWAL PERBAIKAN TOMBOL ---
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
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ), // Tambahkan border putih
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
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(127, 87, 194, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ), // Tambahkan border putih
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Selanjutnya',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
          // --- AKHIR PERBAIKAN TOMBOL ---
        ),
      ],
    );
  }

  // --- AWAL PERBAIKAN FUNGSI DOT ---
  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // --- AKHIR PERBAIKAN FUNGSI DOT ---
}
