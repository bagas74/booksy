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
      _totalKategoriFuture = Future.value(7);
      _totalPenggunaFuture = _adminService.getTotalUsersCount();
    });
  }

  // --- FUNGSI LOGOUT DIPERBAIKI DI SINI ---
  Future<void> _logout() async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Menggunakan nama beda untuk konteks dialog
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(); // Gunakan dialogContext untuk menutup dialog
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Keluar'),
              onPressed: () async {
                // 1. Lakukan proses signOut terlebih dahulu
                await AuthService().signOut();

                // 2. Baru lakukan navigasi setelahnya.
                // pushAndRemoveUntil akan menutup semua halaman termasuk dialog.
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
        child: FutureBuilder<int>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: AppColors.error),
              );
            }
            final count = snapshot.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
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
