// lib/admin/screens/admin_edit_book_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../services/admin_service.dart';
import '../../config/config.dart';

class AdminEditBookScreen extends StatefulWidget {
  final Product book;
  const AdminEditBookScreen({super.key, required this.book});

  @override
  State<AdminEditBookScreen> createState() => _AdminEditBookScreenState();
}

class _AdminEditBookScreenState extends State<AdminEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  // Controllers
  late TextEditingController _judulC;
  late TextEditingController _deskripsiC;
  late TextEditingController _penulisC;
  late TextEditingController _bahasaC;
  late TextEditingController _penerbitC;
  late TextEditingController _halamanC;
  late TextEditingController _formatC;
  final _kategoriC = TextEditingController();

  // State
  DateTime? _tanggalRilis;
  Uint8List? _selectedImageBytes;
  String? _selectedImageExtension;
  String? _existingImageUrl;
  late List<String> _kategoriList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi semua controller dan state dengan data buku yang ada
    _judulC = TextEditingController(text: widget.book.judul);
    _deskripsiC = TextEditingController(text: widget.book.deskripsi);
    _penulisC = TextEditingController(text: widget.book.penulis);
    _bahasaC = TextEditingController(text: widget.book.bahasa);
    _penerbitC = TextEditingController(text: widget.book.penerbit);
    _halamanC = TextEditingController(text: widget.book.halaman.toString());
    _formatC = TextEditingController(text: widget.book.format);
    _tanggalRilis = widget.book.tanggalRilis;
    _existingImageUrl = widget.book.image;
    _kategoriList = List<String>.from(widget.book.kategori);
  }

  @override
  void dispose() {
    _judulC.dispose();
    _deskripsiC.dispose();
    _penulisC.dispose();
    _bahasaC.dispose();
    _penerbitC.dispose();
    _halamanC.dispose();
    _formatC.dispose();
    _kategoriC.dispose();
    super.dispose();
  }

  // Di dalam class _AdminEditBookScreenState

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      if (_tanggalRilis == null) {
        /* ... validasi ... */
        return;
      }

      setState(() => _isLoading = true);
      try {
        String imageUrl = _existingImageUrl!;
        if (_selectedImageBytes != null) {
          imageUrl = await _adminService.uploadFileAsBytes(
            bytes: _selectedImageBytes!,
            fileExtension: _selectedImageExtension!,
            bucketName: 'images',
            isUpdate: true,
            oldImageUrl: _existingImageUrl,
          );
        }

        final bookData = {
          'judul': _judulC.text,
          'image': imageUrl,
          'deskripsi': _deskripsiC.text,
          'penulis': _penulisC.text,
          'bahasa': _bahasaC.text,
          'tanggal_rilis': _tanggalRilis!.toIso8601String(),
          'penerbit': _penerbitC.text,
          'halaman': int.tryParse(_halamanC.text) ?? 0,
          'format': _formatC.text,
          'kategori': _kategoriList,
        };

        await _adminService.updateBook(
          bookId: widget.book.id,
          bookData: bookData,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil diperbarui!'),
              backgroundColor: AppColors.success,
            ),
          );

          // --- PERBAIKAN DI SINI ---
          // Buat objek Product baru dengan data yang sudah diupdate
          final updatedBook = Product(
            id: widget.book.id,
            createdAt: widget.book.createdAt,
            judul: _judulC.text,
            penulis: _penulisC.text,
            kategori: _kategoriList,
            deskripsi: _deskripsiC.text,
            image: imageUrl,
            file: widget.book.file, // Asumsi file tidak diubah di halaman ini
            bahasa: _bahasaC.text,
            halaman: int.tryParse(_halamanC.text) ?? 0,
            penerbit: _penerbitC.text,
            tanggalRilis: _tanggalRilis,
            format: _formatC.text,
            isRekomendasi: widget.book.isRekomendasi,
            isPopuler: widget.book.isPopuler,
          );

          // Kirim kembali objek Product, bukan 'true'
          Navigator.of(context).pop(updatedBook);
        }
      } catch (e) {
        // ... error handling
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      _selectedImageBytes = await image.readAsBytes();
      _selectedImageExtension = image.name.split('.').last;
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _tanggalRilis ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalRilis = pickedDate;
      });
    }
  }

  void _addKategori() {
    if (_kategoriC.text.isNotEmpty &&
        !_kategoriList.contains(_kategoriC.text.trim())) {
      setState(() {
        _kategoriList.add(_kategoriC.text.trim());
        _kategoriC.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Buku')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(controller: _judulC, label: 'Judul Buku'),
              _buildTextFormField(controller: _penulisC, label: 'Penulis'),
              _buildTextFormField(
                controller: _deskripsiC,
                label: 'Deskripsi',
                maxLines: 4,
              ),
              _buildTextFormField(controller: _penerbitC, label: 'Penerbit'),
              _buildTextFormField(controller: _bahasaC, label: 'Bahasa'),
              _buildTextFormField(
                controller: _halamanC,
                label: 'Jumlah Halaman',
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _formatC,
                label: 'Format (e.g., PDF, ePub)',
              ),
              const SizedBox(height: 16),
              _buildKategoriInput(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildKategoriInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children:
              _kategoriList
                  .map(
                    (kategori) => Chip(
                      label: Text(kategori),
                      onDeleted: () {
                        setState(() {
                          _kategoriList.remove(kategori);
                        });
                      },
                    ),
                  )
                  .toList(),
        ),
        TextFormField(
          controller: _kategoriC,
          decoration: InputDecoration(
            hintText: 'Ketik kategori lalu tekan ikon +',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _addKategori,
            ),
          ),
          onFieldSubmitted: (value) => _addKategori(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(
          _tanggalRilis == null
              ? 'Pilih Tanggal Rilis'
              : 'Tanggal Rilis: ${DateFormat('d MMMM yyyy').format(_tanggalRilis!)}',
        ),
        onTap: _pickDate,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gambar Sampul",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          child: ListTile(
            leading: const Icon(Icons.photo_camera),
            title: Text(
              _selectedImageBytes == null
                  ? 'Ganti Gambar Sampul (Opsional)'
                  : 'Gambar Baru Terpilih',
            ),
            subtitle:
                _selectedImageBytes != null
                    ? Text(
                      '${(_selectedImageBytes!.lengthInBytes / 1024).toStringAsFixed(2)} KB',
                    )
                    : null,
            onTap: _pickImage,
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedImageBytes != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_selectedImageBytes!, height: 150),
            ),
          )
        else if (_existingImageUrl != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: _existingImageUrl!,
                height: 150,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
      ],
    );
  }
}
