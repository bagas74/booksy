import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../config/config.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  // State untuk menampung data profil yang akan diambil
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data profil saat halaman dibuka
    _profileFuture = _authService.getProfile();
  }

  /// Menangani proses logout
  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        // Arahkan ke LoginScreen dan hapus semua halaman sebelumnya
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
      ), // Index 3 untuk Profil
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          // --- KONDISI LOADING ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- KONDISI ERROR ---
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // --- KONDISI TIDAK ADA DATA (SEHARUSNYA TIDAK TERJADI) ---
          if (!snapshot.hasData) {
            return const Center(child: Text('Profil tidak ditemukan.'));
          }

          // --- KONDISI SUKSES ---
          final profile = snapshot.data!;
          final email =
              _authService.getCurrentUser()?.email ?? 'Tidak ada email';

          return ListView(
            children: [
              _buildProfileHeader(profile.fullName ?? 'Tanpa Nama', email),
              const SizedBox(height: 20),

              _buildMenuOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profil',
                onTap: () {},
              ),
              _buildMenuOption(
                icon: Icons.lock_outline,
                title: 'Ubah Kata Sandi',
                onTap: () {},
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              _buildMenuOption(
                icon: Icons.logout,
                title: 'Keluar',
                color: AppColors.error,
                onTap: _handleLogout,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String fullName, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      color: AppColors.surface,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(
        title,
        style: TextStyle(color: color ?? AppColors.textPrimary, fontSize: 16),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
