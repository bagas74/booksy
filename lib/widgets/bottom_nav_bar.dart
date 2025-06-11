import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../admin/screens/admin_home_screen.dart';
import '../screens/library_screen.dart';
// import '../screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onTap(int index) {
    // Jika item yang diklik adalah halaman yang sedang aktif, tidak perlu lakukan apa-apa
    if (index == widget.currentIndex) return;

    // Daftar halaman sesuai urutan menu
    // Gunakan null untuk halaman yang belum dibuat
    final List<Widget? Function()> routes = [
      () => const HomeScreen(),
      () => const ExploreScreen(),
      () => const LibraryScreen(),
      () => null, // TODO: Ganti dengan () => const ProfileScreen()
      () => const AdminHomeScreen(),
    ];

    final pageBuilder = routes[index]();
    if (pageBuilder != null) {
      // Menggunakan PageRouteBuilder untuk transisi instan tanpa animasi
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => pageBuilder,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      // Beri feedback jika halaman belum ada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Halaman ini belum tersedia.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Container untuk kustomisasi penuh
    return Container(
      height: 80, // Beri tinggi agar nyaman disentuh
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home_rounded, label: "Home", index: 0),
          _buildNavItem(icon: Icons.search_rounded, label: "Explore", index: 1),
          _buildNavItem(
            icon: Icons.collections_bookmark_rounded,
            label: "Library",
            index: 2,
          ),
          _buildNavItem(icon: Icons.person_rounded, label: "Profil", index: 3),
          _buildNavItem(
            icon: Icons.supervised_user_circle,
            label: "Admin",
            index: 4,
          ),
        ],
      ),
    );
  }

  /// Helper widget untuk membangun setiap item navigasi
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = widget.currentIndex == index;
    final Color activeColor =
        Theme.of(context).primaryColor; // Warna utama tema
    final Color inactiveColor = Colors.grey.shade500;

    return InkWell(
      onTap: () => _onTap(index),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
            // Tampilkan label hanya jika item sedang aktif
            if (isSelected) const SizedBox(width: 8),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
