// lib/ui/splash_screen/splash_screen.dart

import 'package:booksy/services/settings_service.dart'; // <-- 1. Import service baru
import 'package:cached_network_image/cached_network_image.dart'; // <-- 2. Import untuk gambar dari network
import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // <-- 3. Buat instance dari service dan state untuk future
  final SettingsService _settingsService = SettingsService();
  late Future<String> _logoUrlFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk navigasi dan fetch logo
    _navigateToHome();
    _logoUrlFuture =
        _settingsService.getLogoUrl(); // <-- 4. Panggil fungsi dari service
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- AWAL PERUBAHAN LOGO ---
            // Menggunakan FutureBuilder untuk menampilkan logo secara dinamis
            FutureBuilder<String>(
              future: _logoUrlFuture,
              builder: (context, snapshot) {
                // Saat data berhasil dimuat dan URL tidak kosong
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    width: 150,
                    height: 150,
                    placeholder:
                        (context, url) =>
                            const SizedBox(width: 150, height: 150),
                    errorWidget:
                        (context, url, error) => Image.asset(
                          'assets/images/logobooksy.png', // Fallback jika URL error
                          width: 150,
                          height: 150,
                        ),
                  );
                }

                // Saat loading atau jika terjadi error, tampilkan logo lokal
                // Ini juga berfungsi sebagai fallback jika offline
                return Image.asset(
                  'assets/images/logobooksy.png',
                  width: 150,
                  height: 150,
                );
              },
            ),

            // --- AKHIR PERUBAHAN LOGO ---
            const SizedBox(height: 20),
            const Text(
              'Booksy',
              style: TextStyle(
                color: Color.fromRGBO(126, 87, 194, 1),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              // Ganti warna agar kontras dengan background
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(126, 87, 194, 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
