// lib/admin/screens/admin_add_book_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../services/admin_service.dart';
import '../../config/config.dart';

class AdminAddBookScreen extends StatefulWidget {
  const AdminAddBookScreen({super.key});
  @override
  State<AdminAddBookScreen> createState() => _AdminAddBookScreenState();
}

class _AdminAddBookScreenState extends State<AdminAddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  // Controllers
  final _judulC = TextEditingController();
  final _deskripsiC = TextEditingController();
  final _penulisC = TextEditingController();
  final _bahasaC = TextEditingController();
  final _penerbitC = TextEditingController();
  final _halamanC = TextEditingController();
  final _formatC = TextEditingController();

  // State
  DateTime? _tanggalRilis;
  Uint8List? _imageBytes;
  String? _imageExtension;
  Uint8List? _bookFileBytes;
  String? _bookFileExtension;
  String? _bookFileNameOriginal;
  bool _isLoading = false;

  @override
  void dispose() {
    _judulC.dispose();
    _deskripsiC.dispose();
    _penulisC.dispose();
    _bahasaC.dispose();
    _penerbitC.dispose();
    _halamanC.dispose();
    _formatC.dispose();
    super.dispose();
  }

  // Letakkan ini di dalam class _AdminAddBookScreenState

  Future<void> _saveBook() async {
    // 1. Validasi semua input pada form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Validasi tambahan untuk file dan tanggal
    if (_imageBytes == null ||
        _bookFileBytes == null ||
        _tanggalRilis == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi field gambar, file, dan tanggal.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 3. Upload gambar sampul ke bucket 'images' dan dapatkan URL lengkapnya
      final publicImageUrl = await _adminService.uploadFileAsBytes(
        bytes: _imageBytes!,
        fileExtension: _imageExtension!,
        bucketName: 'images',
      );

      // 4. Upload file buku ke bucket 'files' dan dapatkan nama filenya saja
      final bookFileName = await _adminService.uploadFileAsBytes(
        bytes: _bookFileBytes!,
        fileExtension: _bookFileExtension!,
        bucketName: 'files',
      );

      // 5. Siapkan data lengkap untuk dikirim ke database
      final bookData = {
        'judul': _judulC.text.trim(),
        'image': publicImageUrl, // Menyimpan URL lengkap
        'deskripsi': _deskripsiC.text.trim(),
        'penulis': _penulisC.text.trim(),
        'bahasa': _bahasaC.text.trim(),
        'tanggal_rilis': _tanggalRilis!.toIso8601String(),
        'penerbit': _penerbitC.text.trim(),
        'halaman': int.tryParse(_halamanC.text.trim()) ?? 0,
        'format': _formatC.text.trim(),
        'file': bookFileName, // Menyimpan nama file
      };

      // 6. Panggil service untuk menyimpan data ke tabel 'buku'
      await _adminService.addBook(bookData: bookData);

      // 7. Tampilkan notifikasi sukses dan kembali ke halaman sebelumnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku baru berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // 8. Tangani jika ada error selama proses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan buku: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      // 9. Pastikan loading indicator berhenti apa pun hasilnya
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageBytes = await image.readAsBytes();
      _imageExtension = image.name.split('.').last;
      setState(() {});
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );
    if (result != null && result.files.single.bytes != null) {
      _bookFileBytes = result.files.single.bytes;
      _bookFileExtension = result.files.single.extension;
      _bookFileNameOriginal = result.files.single.name;
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalRilis = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Buku Baru')),
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
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildFilePicker(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveBook,
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
                          'Simpan Buku',
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

  // Di dalam class _AdminAddBookScreenState

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gambar Sampul",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        // Tampilkan preview gambar JIKA sudah dipilih
        if (_imageBytes != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _imageBytes!,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
        const SizedBox(height: 8),
        // Tombol untuk memilih gambar
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          child: ListTile(
            leading: const Icon(Icons.photo_camera),
            title: Text(
              _imageBytes == null
                  ? 'Pilih Gambar Sampul'
                  : 'Ganti Gambar Sampul',
            ),
            subtitle:
                _imageBytes != null
                    ? Text(
                      '${(_imageBytes!.lengthInBytes / 1024).toStringAsFixed(2)} KB',
                    )
                    : null,
            onTap: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: ListTile(
        leading: const Icon(Icons.attach_file),
        title: Text(
          _bookFileBytes == null
              ? 'Pilih File Buku (PDF/ePub)'
              : 'File Buku Terpilih',
        ),
        subtitle:
            _bookFileNameOriginal != null ? Text(_bookFileNameOriginal!) : null,
        onTap: _pickFile,
      ),
    );
  }
}
