import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booksy/services/supabase_service.dart';

class RiwayatPeminjamanScreen extends StatefulWidget {
  const RiwayatPeminjamanScreen({super.key});

  @override
  State<RiwayatPeminjamanScreen> createState() =>
      _RiwayatPeminjamanScreenState();
}

class _RiwayatPeminjamanScreenState extends State<RiwayatPeminjamanScreen> {
  final SupabaseService _service = SupabaseService();
  String _cari = '';
  List<Map<String, dynamic>> riwayat = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final data = await _service.fetchRiwayat();
      setState(() {
        riwayat = data;
      });
    } catch (e) {
      debugPrint('❌ Gagal fetch riwayat: $e');
    }
  }

  String getStatus(Map<String, dynamic> data) {
    if (data['sudah_dikembalikan'] == true) {
      return 'Sudah Dikembalikan';
    } else if (DateTime.now().isAfter(
      DateTime.parse(data['tanggal_kembali']),
    )) {
      return 'Belum Dikembalikan';
    } else {
      return 'Masih Dipinjam';
    }
  }

  String formatTanggal(String tanggal) {
    final parsed = DateTime.parse(tanggal);
    return DateFormat('d MMMM yyyy', 'id_ID').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final hasil =
        riwayat.where((r) {
          return r['judul'].toString().toLowerCase().contains(
                _cari.toLowerCase(),
              ) ||
              r['user'].toString().toLowerCase().contains(_cari.toLowerCase());
        }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Riwayat Peminjaman"),
        backgroundColor: const Color.fromARGB(221, 205, 122, 236),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            debugPrint('⬅️ Tombol kembali ditekan');
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context, rootNavigator: true).maybePop();
            }
          },
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
              child:
                  hasil.isEmpty
                      ? const Center(child: Text("Data tidak ditemukan."))
                      : ListView.builder(
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("User: ${r['user']}"),
                                  Text(
                                    "Pinjam: ${formatTanggal(r['tanggal_pinjam'])}",
                                  ),
                                  Text(
                                    "Kembali: ${formatTanggal(r['tanggal_kembali'])}",
                                  ),
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
