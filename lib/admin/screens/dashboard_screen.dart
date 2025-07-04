import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/login_screen.dart';
import 'kelola_buku_screen.dart';
import 'kelola_kategori_screen.dart';
import 'kelola_pengguna_screen.dart';
import 'riwayat_peminjaman_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return formatter.format(now);
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus data login

    // Arahkan ke halaman login dan hapus semua halaman sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _logout(context); // Panggil fungsi logout
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: const Color.fromARGB(221, 205, 122, 236),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Halo Admin 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _getFormattedDate(),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari buku...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatBox(label: "Total Buku", value: "100"),
                  _StatBox(label: "Total Kategori", value: "7"),
                  _StatBox(label: "Total Pengguna", value: "25"),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                "Menu Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _AdminMenuTile(
                icon: Icons.book,
                label: "Kelola Buku",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KelolaBukuScreen(),
                    ),
                  );
                },
              ),
              _AdminMenuTile(
                icon: Icons.category,
                label: "Kelola Kategori",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KelolaKategoriScreen(),
                    ),
                  );
                },
              ),
              _AdminMenuTile(
                icon: Icons.people,
                label: "Kelola Pengguna",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KelolaPenggunaScreen(),
                    ),
                  );
                },
              ),
              _AdminMenuTile(
                icon: Icons.history,
                label: "Riwayat Peminjaman",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RiwayatPeminjamanScreen(),
                    ),
                  );
                },
              ),
              _AdminMenuTile(
                icon: Icons.logout,
                label: "Keluar",
                onTap: () => _showLogoutConfirmation(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Statistik Box
class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// ✅ Menu Navigasi Admin
class _AdminMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
