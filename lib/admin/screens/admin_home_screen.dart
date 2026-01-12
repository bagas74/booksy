// lib/admin/screens/admin_home_screen.dart

import 'package:flutter/material.dart';
import '../../config/config.dart';
import '../../services/auth_service.dart';
import '../../services/admin_service.dart';
import '../../screens/login_screen.dart';
import 'admin_manage_books_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AdminService _adminService = AdminService();

  late Future<int> _totalBukuFuture;
  late Future<int> _totalKategoriFuture;
  late Future<int> _totalPenggunaFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _totalBukuFuture = _adminService.getTotalBooksCount();
      _totalKategoriFuture = Future.value(7); // Kategori diatur statis
      _totalPenggunaFuture = _adminService.getTotalUsersCount();
    });
  }

  // --- FUNGSI LOGOUT DIPERBAIKI DI SINI ---
  Future<void> _logout() async {
    // Menampilkan dialog konfirmasi
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false); // Kirim 'false' saat batal
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Keluar'),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true); // Kirim 'true' saat konfirmasi
              },
            ),
          ],
        );
      },
    );

    // Lakukan aksi HANYA JIKA user menekan tombol 'Keluar'
    if (shouldLogout == true && mounted) {
      await AuthService().signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh Data',
            onPressed: _loadStats,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  _buildStatCard(_totalBukuFuture, 'Total Buku'),
                  const SizedBox(width: 16),
                  _buildStatCard(_totalKategoriFuture, 'Total Kategori'),
                  const SizedBox(width: 16),
                  _buildStatCard(_totalPenggunaFuture, 'Total Pengguna'),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Menu Admin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                  /* TODO: Navigasi */
                },
              ),
              _buildMenuItem(
                icon: Icons.people_alt_rounded,
                title: 'Kelola Pengguna',
                onTap: () {
                  /* TODO: Navigasi */
                },
              ),
              _buildMenuItem(
                icon: Icons.history_rounded,
                title: 'Riwayat Peminjaman',
                onTap: () {
                  /* TODO: Navigasi */
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

  Widget _buildStatCard(Future<int> future, String label) {
    return Expanded(
      child: Container(
        // ... (implementasi tidak berubah)
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      // ... (implementasi tidak berubah)
    );
  }
}
