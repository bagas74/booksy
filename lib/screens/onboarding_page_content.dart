// lib/screens/onboarding_page_content.dart

import 'package:flutter/material.dart';
import 'package:booksy/models/onboarding_item.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;
  final int index;

  const OnboardingPageContent({
    super.key,
    required this.item,
    required this.index,
  });

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
            // --- PERBAIKAN: Gunakan item.imageUrl ---
            child: Image.asset(
              item.imageUrl, // Mengambil path yang benar dari OnboardingScreen
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Debugging: Print error ke console agar tahu kenapa gagal
                debugPrint("Gagal memuat gambar: ${item.imageUrl} -> $error");

                return const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                );
              },
            ),
            // --- AKHIR PERBAIKAN ---
          ),
        ),
        // ... kode bagian text di bawah tetap sama ...
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
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  item.description,
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
