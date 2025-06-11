// lib/ui/splash_screen/splash_screen.dart

import 'package:booksy/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Diperlukan untuk Future.delayed
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk navigasi setelah splash screen tampil
    _navigateToHome();
  }

  // Fungsi untuk menunda navigasi dan kemudian pindah ke halaman utama
  _navigateToHome() async {
    // Menunggu selama 3 detik. Kamu bisa sesuaikan durasinya.
    await Future.delayed(const Duration(seconds: 3), () {});

    // Navigasi ke HomePage setelah penundaan.
    // pushReplacement digunakan agar pengguna tidak bisa kembali ke splash screen
    // dengan tombol back.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        252,
        252,
        252,
      ), // Warna latar belakang splash screen
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: <Widget>[
            // Widget untuk menampilkan logo.
            // Pastikan kamu punya file gambar logo di 'assets/images/logo.png'
            Image.asset(
              'assets/images/logobooksy.png', // Sesuaikan path jika berbeda
              width: 150, // Sesuaikan lebar logo
              height: 150, // Sesuaikan tinggi logo
              // fit: BoxFit.contain, // Opsional: cara gambar menyesuaikan diri
            ),
            const SizedBox(height: 20), // Spasi vertikal antara logo dan teks
            // Teks nama aplikasi "Booksy"
            const Text(
              'Booksy',
              style: TextStyle(
                color: Color.fromRGBO(27, 133, 255, 1), // Warna teks putih
                fontSize: 48, // Ukuran font besar
                fontWeight: FontWeight.bold, // Teks tebal
                // fontFamily: 'Montserrat', // Opsional: Gunakan custom font jika sudah ditambahkan di pubspec.yaml
              ),
            ),
            const SizedBox(height: 30), // Spasi vertikal di bawah teks
            // Indikator loading (lingkaran berputar)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ), // Warna indikator putih
            ),
          ],
        ),
      ),
    );
  }
}
