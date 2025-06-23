import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../widgets/borrowed_book_card.dart';
import '../config/config.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/borrow_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final BorrowService _borrowService = BorrowService();

  late Future<List<Peminjaman>> _currentlyBorrowedFuture;
  late Future<List<Peminjaman>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _currentlyBorrowedFuture = _borrowService.fetchBorrows(
      isCurrentlyBorrowed: true,
    );
    _historyFuture = _borrowService.fetchBorrows(isCurrentlyBorrowed: false);
  }

  Future<void> _handleReturnBook(String peminjamanId) async {
    try {
      await _borrowService.returnBook(peminjamanId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dikembalikan.'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      setState(() {
        _loadData();
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. KEMBALIKAN DefaultTabController sebagai widget paling atas
    return DefaultTabController(
      length: 2, // Kita punya 2 tab
      child: Scaffold(
        backgroundColor: AppColors.background,
        // 2. KEMBALIKAN AppBar
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text('Perpustakaan'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [Tab(text: 'Sedang Dipinjam'), Tab(text: 'Riwayat')],
          ),
        ),
        // 3. KEMBALIKAN BottomNavBar
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
        // 4. KEMBALIKAN TabBarView untuk menampung kedua list
        body: TabBarView(
          children: [
            // Konten untuk Tab 1: Sedang Dipinjam
            _buildBorrowList(
              future: _currentlyBorrowedFuture,
              isCurrentlyBorrowed: true,
            ),
            // Konten untuk Tab 2: Riwayat
            _buildBorrowList(
              future: _historyFuture,
              isCurrentlyBorrowed: false,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membangun daftar buku dengan FutureBuilder
  Widget _buildBorrowList({
    required Future<List<Peminjaman>> future,
    required bool isCurrentlyBorrowed,
  }) {
    return FutureBuilder<List<Peminjaman>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final borrows = snapshot.data ?? [];
        if (borrows.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.collections_bookmark_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tidak ada Riwayat',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: borrows.length,
          itemBuilder: (context, index) {
            final peminjaman = borrows[index];
            return BorrowedBookCard(
              peminjaman: peminjaman,
              onReturn: () => _handleReturnBook(peminjaman.id),
            );
          },
        );
      },
    );
  }
}
