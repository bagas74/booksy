import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPeminjamanScreen extends StatefulWidget {
  const RiwayatPeminjamanScreen({super.key});

  @override
  State<RiwayatPeminjamanScreen> createState() =>
      _RiwayatPeminjamanScreenState();
}

class _RiwayatPeminjamanScreenState extends State<RiwayatPeminjamanScreen> {
  String _cari = '';

  final List<Map<String, dynamic>> riwayat = [
    {
      'judul': 'Si Putih',
      'user': 'Joko Susilo',
      'pinjam': DateTime(2025, 5, 26),
      'kembali': DateTime(2025, 6, 8),
      'sudahDikembalikan': true,
    },
    {
      'judul': 'Laut Bercerita',
      'user': 'Dinda Laras',
      'pinjam': DateTime(2025, 6, 1),
      'kembali': DateTime(2025, 6, 15),
      'sudahDikembalikan': false,
    },
    {
      'judul': 'Garis Waktu',
      'user': 'Joko Susilo',
      'pinjam': DateTime(2025, 5, 1),
      'kembali': DateTime(2025, 5, 15),
      'sudahDikembalikan': true,
    },
  ];

  String getStatus(Map<String, dynamic> data) {
    if (data['sudahDikembalikan'] == true) {
      return 'Sudah Dikembalikan';
    } else if (DateTime.now().isAfter(data['kembali'])) {
      return 'Belum Dikembalikan';
    } else {
      return 'Masih Dipinjam';
    }
  }

  String formatTanggal(DateTime tanggal) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  }

  @override
  Widget build(BuildContext context) {
    final hasil =
        riwayat
            .where(
              (r) =>
                  r['judul'].toString().toLowerCase().contains(
                    _cari.toLowerCase(),
                  ) ||
                  r['user'].toString().toLowerCase().contains(
                    _cari.toLowerCase(),
                  ),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Riwayat Peminjaman"),
        backgroundColor: const Color.fromARGB(221, 205, 122, 236),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Cari pengguna/buku",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _cari = val),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: hasil.length,
                itemBuilder: (context, i) {
                  final r = hasil[i];
                  final status = getStatus(r);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Judul Novel: ${r['judul']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("User: ${r['user']}"),
                          Text("Pinjam: ${formatTanggal(r['pinjam'])}"),
                          Text("Kembali: ${formatTanggal(r['kembali'])}"),
                          Text(
                            "Status: $status",
                            style: TextStyle(
                              color:
                                  status == 'Belum Dikembalikan'
                                      ? Colors.red
                                      : status == 'Masih Dipinjam'
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
