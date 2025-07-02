import 'package:flutter/material.dart';

class KelolaBukuScreen extends StatefulWidget {
  const KelolaBukuScreen({super.key});

  @override
  State<KelolaBukuScreen> createState() => _KelolaBukuScreenState();
}

class _KelolaBukuScreenState extends State<KelolaBukuScreen> {
  List<Map<String, String>> daftarBuku = [
    {'judul': 'Si Putih', 'penulis': 'Tere Liye'},
    {'judul': 'Laut Bercerita', 'penulis': 'Leila S. Chudori'},
  ];

  String _cari = '';

  void _tambahBuku() {
    String judulBaru = '';
    String penulisBaru = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Buku"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                onChanged: (value) => judulBaru = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Penulis'),
                onChanged: (value) => penulisBaru = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (judulBaru.isNotEmpty && penulisBaru.isNotEmpty) {
                  setState(() {
                    daftarBuku.add({
                      'judul': judulBaru,
                      'penulis': penulisBaru,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _editBuku(int index) {
    String judulEdit = daftarBuku[index]['judul']!;
    String penulisEdit = daftarBuku[index]['penulis']!;
    final judulController = TextEditingController(text: judulEdit);
    final penulisController = TextEditingController(text: penulisEdit);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Buku"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
              ),
              TextField(
                controller: penulisController,
                decoration: const InputDecoration(labelText: 'Penulis'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  daftarBuku[index]['judul'] = judulController.text;
                  daftarBuku[index]['penulis'] = penulisController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _hapusBuku(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Buku"),
            content: const Text("Yakin ingin menghapus buku ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    daftarBuku.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text("Hapus"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasilFilter =
        daftarBuku
            .where(
              (buku) =>
                  buku['judul']!.toLowerCase().contains(_cari.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Kelola Buku'),
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
              decoration: InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => _cari = value),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _tambahBuku,
                icon: const Icon(Icons.add),
                label: const Text("Tambah Buku"),
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
                  hasilFilter.isEmpty
                      ? const Center(child: Text("Tidak ada buku ditemukan."))
                      : ListView.builder(
                        itemCount: hasilFilter.length,
                        itemBuilder: (context, index) {
                          final buku = hasilFilter[index];
                          final originalIndex = daftarBuku.indexOf(buku);
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: const Icon(Icons.image, size: 40),
                              title: Text(
                                buku['judul'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(buku['penulis'] ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _editBuku(originalIndex),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _hapusBuku(originalIndex),
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
