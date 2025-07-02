import 'package:flutter/material.dart';

class KelolaKategoriScreen extends StatefulWidget {
  const KelolaKategoriScreen({super.key});

  @override
  State<KelolaKategoriScreen> createState() => _KelolaKategoriScreenState();
}

class _KelolaKategoriScreenState extends State<KelolaKategoriScreen> {
  List<String> daftarKategori = ['Fiksi', 'Non-Fiksi', 'Teknologi', 'Sejarah'];
  String _cari = '';

  void _tambahKategori() {
    String kategoriBaru = '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Tambah Kategori"),
            content: TextField(
              decoration: const InputDecoration(labelText: 'Nama Kategori'),
              onChanged: (value) => kategoriBaru = value,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (kategoriBaru.isNotEmpty) {
                    setState(() {
                      daftarKategori.add(kategoriBaru);
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  void _editKategori(int index) {
    String kategoriEdit = daftarKategori[index];
    final controller = TextEditingController(text: kategoriEdit);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Kategori"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Nama Kategori'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      daftarKategori[index] = controller.text;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  void _hapusKategori(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Kategori"),
            content: const Text("Yakin ingin menghapus kategori ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    daftarKategori.removeAt(index);
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
        daftarKategori
            .where(
              (kategori) =>
                  kategori.toLowerCase().contains(_cari.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Kelola Kategori"),
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
                hintText: 'Cari kategori...',
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
                  hasilFilter.isEmpty
                      ? const Center(child: Text("Kategori tidak ditemukan."))
                      : ListView.builder(
                        itemCount: hasilFilter.length,
                        itemBuilder: (context, index) {
                          final kategori = hasilFilter[index];
                          final originalIndex = daftarKategori.indexOf(
                            kategori,
                          );
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                kategori,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed:
                                        () => _editKategori(originalIndex),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _hapusKategori(originalIndex),
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
