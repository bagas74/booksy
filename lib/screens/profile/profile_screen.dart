import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../../config/config.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  late Future<Profile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _authService.getProfile();
  }

  /// Menangani proses logout dengan dialog konfirmasi
  Future<void> _handleLogout() async {
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text('Anda yakin ingin keluar dari akun Anda?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Ya, Keluar',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );

    if (didConfirm == true) {
      try {
        await _authService.signOut();
        if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Gagal memuat profil: ${snapshot.error}'),
            );
          }

          final profile = snapshot.data!;
          final email =
              _authService.getCurrentUser()?.email ?? 'Tidak ada email';

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _profileFuture = _authService.getProfile();
              });
            },
            child: ListView(
              children: [
                // --- PERUBAHAN DI SINI ---
                // Mengirim seluruh objek profile ke helper method
                _buildProfileHeader(profile, email),
                const SizedBox(height: 20),

                _buildMenuOption(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => EditProfileScreen(currentProfile: profile),
                      ),
                    ).then(
                      (_) => setState(() {
                        _profileFuture = _authService.getProfile();
                      }),
                    );
                  },
                ),
                _buildMenuOption(
                  icon: Icons.lock_outline,
                  title: 'Ubah Kata Sandi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
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
            ),
          );
        },
      ),
    );
  }

  /// Helper widget untuk header profil
  Widget _buildProfileHeader(Profile profile, String email) {
    final String fullName = profile.fullName ?? 'Tanpa Nama';
    final String? avatarUrl = profile.avatarUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      color: AppColors.surface,
      child: Column(
        children: [
          // --- PERUBAHAN DI SINI ---
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            // Gunakan backgroundImage untuk menampilkan gambar dari URL
            backgroundImage:
                (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
            // Tampilkan ikon HANYA jika tidak ada gambar
            child:
                (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    )
                    : null,
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

  /// Helper widget untuk setiap item menu
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
