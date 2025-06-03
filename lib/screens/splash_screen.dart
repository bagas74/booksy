// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async'; // Diperlukan untuk Future.delayed

// Mengarahkan ke OnboardingScreen yang baru, yang juga berada di folder 'screens'
import 'package:nama_aplikasi_kamu/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(); // Mengganti nama fungsi agar lebih generik
  }

  // Fungsi untuk menunda navigasi dan kemudian pindah ke halaman berikutnya
  _navigateToNextScreen() async {
    // Menunggu selama 3 detik. Kamu bisa sesuaikan durasinya.
    await Future.delayed(const Duration(seconds: 3), () {});

    // Navigasi ke OnboardingScreen setelah penundaan.
    // pushReplacement digunakan agar pengguna tidak bisa kembali ke splash screen
    // dengan tombol back.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()), // Navigasi ke OnboardingScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252), // Warna latar belakang splash screen (putih)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: <Widget>[
            // Widget untuk menampilkan logo.
            // Pastikan kamu punya file gambar logo di 'assets/images/logobooksy.png'
            Image.asset(
              'assets/images/logobooksy.png', // Path logo kamu
              width: 150, // Sesuaikan lebar logo
              height: 150, // Sesuaikan tinggi logo
              // fit: BoxFit.contain, // Opsional: cara gambar menyesuaikan diri
            ),
            const SizedBox(height: 20), // Spasi vertikal antara logo dan teks
            // Teks nama aplikasi "Booksy"
            const Text(
              'Booksy',
              style: TextStyle(
                color: Color.fromRGBO(27, 133, 255, 1), // Warna teks (biru)
                fontSize: 48, // Ukuran font besar
                fontWeight: FontWeight.bold, // Teks tebal
                // fontFamily: 'Montserrat', // Opsional: Gunakan custom font jika sudah ditambahkan di pubspec.yaml
              ),
            ),
            const SizedBox(height: 30), // Spasi vertikal di bawah teks
            // Indikator loading (lingkaran berputar)
            CircularProgressIndicator(
              // Ubah warna indikator agar terlihat di latar belakang putih
              // Misalnya, gunakan warna yang sama dengan teks atau warna gelap
              valueColor: AlwaysStoppedAnimation<Color>(const Color.fromRGBO(27, 133, 255, 1)), // Menggunakan warna biru yang sama dengan teks
            ),
          ],
        ),
      ),
    );
  }
}