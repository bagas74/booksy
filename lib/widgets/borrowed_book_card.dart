import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../config/config.dart';
import '../screens/product_detail.dart';

class BorrowedBookCard extends StatelessWidget {
  final Peminjaman peminjaman;
  final VoidCallback onReturn;

  const BorrowedBookCard({
    super.key,
    required this.peminjaman,
    required this.onReturn,
  });

  // --- FUNGSI BARU UNTUK MENAMPILKAN DIALOG KONFIRMASI ---
  Future<void> _showReturnConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User bisa klik di luar dialog untuk batal
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Konfirmasi Pengembalian'),
          content: Text(
            'Anda yakin ingin mengembalikan buku "${peminjaman.buku.judul}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                // Tutup dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                // 1. Tutup dialog terlebih dahulu
                Navigator.of(dialogContext).pop();
                // 2. Jalankan fungsi onReturn yang asli dari LibraryScreen
                onReturn();
              },
              child: const Text(
                'Ya, Kembalikan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrentlyBorrowed = peminjaman.tanggalKembali == null;
    final int totalDays =
        peminjaman.batasWaktu.difference(peminjaman.tanggalPinjam).inDays;
    final int daysLeft =
        peminjaman.batasWaktu.difference(DateTime.now()).inDays;
    final double progress =
        totalDays > 0 ? (totalDays - daysLeft) / totalDays : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetail(product: peminjaman.buku),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      peminjaman.buku.image,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peminjaman.buku.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          peminjaman.buku.penulis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (isCurrentlyBorrowed)
              _buildProgressBar(progress, daysLeft)
            else
              _buildReturnedInfo(),

            if (isCurrentlyBorrowed) ...[
              const Divider(height: 24, thickness: 0.5),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: TextButton(
                  // --- PERUBAHAN UTAMA DI SINI ---
                  // Tombol ini sekarang memanggil dialog, bukan onReturn secara langsung
                  onPressed: () => _showReturnConfirmationDialog(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Kembalikan Buku'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ... (Helper widget _buildProgressBar dan _buildReturnedInfo tidak berubah)
  Widget _buildProgressBar(double progress, int daysLeft) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress < 0 ? 0 : (progress > 1 ? 1 : progress),
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          daysLeft > 0
              ? 'Batas waktu: $daysLeft hari lagi'
              : 'Batas waktu telah habis',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildReturnedInfo() {
    return Text(
      'Dikembalikan pada: ${DateFormat('dd MMM yy').format(peminjaman.tanggalKembali!)}',
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.success,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
