import 'package:flutter/material.dart';
import 'package:booksy/models/kategori.dart';
import 'package:booksy/services/supabase_service.dart';

class KelolaKategoriScreen extends StatefulWidget {
  const KelolaKategoriScreen({super.key});

  @override
  State<KelolaKategoriScreen> createState() => _KelolaKategoriScreenState();
}

class _KelolaKategoriScreenState extends State<KelolaKategoriScreen> {
  final SupabaseService _service = SupabaseService();
  List<Kategori> daftarKategori = [];
  String _cari = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    setState(() => isLoading = true);
    try {
      daftarKategori = await _service.fetchKategori();
    } catch (e) {
      print('Gagal ambil kategori: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memuat kategori")));
    }
    setState(() => isLoading = false);
  }

  void _tambahKategori() {
    final controller = TextEditingController();
    bool isValid = false;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: const Text("Tambah Kategori"),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Nama Kategori",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setStateDialog(() {
                      isValid = val.trim().isNotEmpty;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed:
                        isValid
                            ? () async {
                              await _service.tambahKategori(
                                controller.text.trim(),
                              );
                              Navigator.pop(context);
                              fetchKategori();
                            }
                            : null,
                    child: const Text("Simpan"),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _hapusKategori(Kategori kategori) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus Kategori"),
            content: Text('Yakin ingin menghapus "${kategori.nama}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _service.hapusKategori(kategori.id);
                  Navigator.pop(context);
                  fetchKategori();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasilFilter =
        daftarKategori
            .where(
              (kat) => kat.nama.toLowerCase().contains(_cari.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Kategori"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) => setState(() => _cari = val),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _tambahKategori,
                icon: const Icon(Icons.add),
                label: const Text("Tambah Kategori"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : hasilFilter.isEmpty
                      ? const Center(child: Text("Kategori tidak ditemukan."))
                      : ListView.builder(
                        itemCount: hasilFilter.length,
                        itemBuilder: (context, index) {
                          final kategori = hasilFilter[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                kategori.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _hapusKategori(kategori),
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
