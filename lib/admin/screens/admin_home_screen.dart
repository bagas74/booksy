// lib/admin/screens/admin_home_screen.dart

import 'package:flutter/material.dart';
import '../../config/config.dart'; // Pastikan import AppColors
import '../../services/auth_service.dart';
import '../../screens/login_screen.dart';
import 'admin_manage_books_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Nanti kita akan isi data ini dari Supabase
  final String _totalBuku = "100";
  final String _totalKategori = "7";
  final String _totalPengguna = "25";

  // Fungsi untuk logout
  Future<void> _logout() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Keluar'),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog sebelum navigasi
                await AuthService().signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Atur warna latar belakang utama
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // AppBar dengan gaya dari desain
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary, // Gunakan warna ungu dari AppColors
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari buku...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Kartu Statistik
              Row(
                children: [
                  _buildStatCard(_totalBuku, 'Total Buku'),
                  const SizedBox(width: 16),
                  _buildStatCard(_totalKategori, 'Total Kategori'),
                  const SizedBox(width: 16),
                  _buildStatCard(_totalPengguna, 'Total Pengguna'),
                ],
              ),
              const SizedBox(height: 32),

              // Judul Menu
              const Text(
                'Menu Admin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Daftar Menu
              _buildMenuItem(
                icon: Icons.book_rounded,
                title: 'Kelola Buku',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminManageBooksScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.category_rounded,
                title: 'Kelola Kategori',
                onTap: () {
                  /* TODO: Navigasi ke halaman kelola kategori */
                },
              ),
              _buildMenuItem(
                icon: Icons.people_alt_rounded,
                title: 'Kelola Pengguna',
                onTap: () {
                  /* TODO: Navigasi ke halaman kelola pengguna */
                },
              ),
              _buildMenuItem(
                icon: Icons.history_rounded,
                title: 'Riwayat Peminjaman',
                onTap: () {
                  /* TODO: Navigasi ke halaman riwayat */
                },
              ),
              const Divider(height: 32),
              _buildMenuItem(
                icon: Icons.exit_to_app_rounded,
                title: 'Keluar',
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk kartu statistik
  Widget _buildStatCard(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk item menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0, // Gunakan shadow dari container di atas jika perlu
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
