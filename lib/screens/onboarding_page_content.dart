// lib/screens/onboarding_page_content.dart

import 'package:cached_network_image/cached_network_image.dart'; // <-- 1. Import ditambahkan
import 'package:flutter/material.dart';
import 'package:booksy/models/onboarding_item.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item; // Menerima data melalui konstruktor

  const OnboardingPageContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.all(20),
            // --- AWAL PERUBAHAN ---
            // Mengganti Image.asset dengan CachedNetworkImage
            child: CachedNetworkImage(
              imageUrl: item.imageUrl, // Menggunakan imageUrl dari item model
              fit: BoxFit.contain,
              // Tampilkan indikator loading saat gambar sedang diunduh
              placeholder:
                  (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              // Tampilkan ikon jika URL gambar error atau tidak bisa diakses
              errorWidget:
                  (context, url, error) => Icon(
                    Icons.image,
                    size: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.white38,
                  ),
            ),
            // --- AKHIR PERUBAHAN ---
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.title, // Menggunakan data dari item
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  item.description, // Menggunakan data dari item
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
