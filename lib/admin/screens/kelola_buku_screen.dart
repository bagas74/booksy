import 'package:flutter/material.dart';
import 'package:booksy/models/buku.dart';
import 'package:booksy/models/kategori.dart';
import 'package:booksy/services/supabase_service.dart';

class KelolaBukuScreen extends StatefulWidget {
  const KelolaBukuScreen({super.key});

  @override
  State<KelolaBukuScreen> createState() => _KelolaBukuScreenState();
}

class _KelolaBukuScreenState extends State<KelolaBukuScreen> {
  List<Buku> daftarBuku = [];
  List<Kategori> daftarKategori = [];
  String _cari = '';
  final SupabaseService _service = SupabaseService();
  bool isLoadingKategori = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoadingKategori = true);
    try {
      daftarKategori = await _service.fetchKategori();
      daftarBuku = await _service.fetchBuku();
    } catch (e) {
      print('Gagal fetch data: $e');
    }
    setState(() => isLoadingKategori = false);
  }

  void _showTambahDialog() {
    final judulController = TextEditingController();
    final penulisController = TextEditingController();
    int? selectedKategoriId;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tambah Buku"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Buku',
                      ),
                    ),
                    TextField(
                      controller: penulisController,
                      decoration: const InputDecoration(labelText: 'Penulis'),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      value: selectedKategoriId,
                      items:
                          daftarKategori.map((kategori) {
                            return DropdownMenuItem<int>(
                              value: kategori.id,
                              child: Text(kategori.nama),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setStateDialog(() => selectedKategoriId = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            if (judulController.text.isEmpty ||
                                penulisController.text.isEmpty ||
                                selectedKategoriId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Judul, Penulis, dan Kategori wajib diisi.",
                                  ),
                                ),
                              );
                              return;
                            }

                            setStateDialog(() => isLoading = true);
                            try {
                              await _service.tambahBuku(
                                judulController.text,
                                penulisController.text,
                                selectedKategoriId!,
                              );
                              Navigator.pop(context);
                              fetchData();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal menyimpan buku: $e"),
                                ),
                              );
                            }
                            setStateDialog(() => isLoading = false);
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasilFilter =
        daftarBuku
            .where((b) => b.judul.toLowerCase().contains(_cari.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Buku"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _cari = value),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: isLoadingKategori ? null : _showTambahDialog,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Buku"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  hasilFilter.isEmpty
                      ? const Center(child: Text("Tidak ada buku."))
                      : ListView.builder(
                        itemCount: hasilFilter.length,
                        itemBuilder: (context, index) {
                          final buku = hasilFilter[index];
                          final kategori = daftarKategori.firstWhere(
                            (kat) => kat.id == buku.kategoriId,
                            orElse: () => Kategori(id: 0, nama: '-'),
                          );
                          return Card(
                            child: ListTile(
                              title: Text(buku.judul),
                              subtitle: Text(
                                "${buku.penulis} - ${kategori.nama}",
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
