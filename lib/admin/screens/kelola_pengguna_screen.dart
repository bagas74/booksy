// Tambah dependensi di pubspec.yaml jika belum:
// showDialog, TextEditingController
import 'package:flutter/material.dart';

class KelolaPenggunaScreen extends StatefulWidget {
  const KelolaPenggunaScreen({super.key});

  @override
  State<KelolaPenggunaScreen> createState() => _KelolaPenggunaScreenState();
}

class _KelolaPenggunaScreenState extends State<KelolaPenggunaScreen> {
  List<Map<String, String>> pengguna = [
    {
      'nama': 'Joko Susilo',
      'email': 'joko@gmail.com',
      'role': 'Anggota',
      'status': 'Aktif',
    },
    {
      'nama': 'Wicaksono Bayu',
      'email': 'wicaksono.admin@gmail.com',
      'role': 'Admin',
      'status': 'Aktif',
    },
  ];

  String _cari = '';

  void _tambahAtauEdit({Map<String, String>? data, int? index}) {
    final namaController = TextEditingController(text: data?['nama'] ?? '');
    final emailController = TextEditingController(text: data?['email'] ?? '');
    String role = data?['role'] ?? 'Anggota';
    String status = data?['status'] ?? 'Aktif';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(index == null ? 'Tambah Pengguna' : 'Edit Pengguna'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items:
                        ['Admin', 'Anggota']
                            .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)),
                            )
                            .toList(),
                    onChanged: (val) => role = val!,
                  ),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items:
                        ['Aktif', 'Tidak Aktif']
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                    onChanged: (val) => status = val!,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final userBaru = {
                    'nama': namaController.text,
                    'email': emailController.text,
                    'role': role,
                    'status': status,
                  };
                  setState(() {
                    if (index == null) {
                      pengguna.add(userBaru);
                    } else {
                      pengguna[index] = userBaru;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _hapus(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Pengguna'),
            content: const Text('Yakin ingin menghapus pengguna ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => pengguna.removeAt(index));
                  Navigator.pop(context);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil =
        pengguna
            .where(
              (p) =>
                  p['nama']!.toLowerCase().contains(_cari.toLowerCase()) ||
                  p['email']!.toLowerCase().contains(_cari.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Kelola Pengguna"),
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
                hintText: "Cari pengguna",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _cari = val),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _tambahAtauEdit(),
              icon: const Icon(Icons.add),
              label: const Text("Tambah Pengguna"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: hasil.length,
                itemBuilder: (context, i) {
                  final p = hasil[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama : ${p['nama']}"),
                                Text("Email : ${p['email']}"),
                                Text("Role : ${p['role']}"),
                                Text("Status : ${p['status']}"),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    () => _tambahAtauEdit(data: p, index: i),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _hapus(i),
                              ),
                            ],
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
