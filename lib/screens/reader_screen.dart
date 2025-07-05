import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/product.dart';

class ReaderScreen extends StatefulWidget {
  final Product product;
  const ReaderScreen({super.key, required this.product});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // State untuk menyimpan konten teks dari file
  late Future<String> _textContentFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat konten teks saat halaman dibuka
    _textContentFuture = _loadTextContent();
  }

  /// Mengambil konten file .txt dari Supabase Storage
  Future<String> _loadTextContent() async {
    try {
      final String fileName = widget.product.file;
      if (fileName.isEmpty) {
        throw Exception('Nama file kosong di database.');
      }

      const String textBucketName = 'files'; // Sesuaikan nama bucket

      // Mengunduh file sebagai byte
      final fileBytes = await Supabase.instance.client.storage
          .from(textBucketName)
          .download(fileName);

      // Mengubah byte menjadi String (menggunakan UTF-8)
      final String content = utf8.decode(fileBytes);
      return content;
    } catch (error) {
      debugPrint("Error loading text file: $error");
      // Melempar error kembali agar bisa ditangkap oleh FutureBuilder
      throw Exception('Gagal memuat konten buku.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.judul),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<String>(
        future: _textContentFuture,
        builder: (context, snapshot) {
          // --- State Saat Loading ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- State Saat Terjadi Error ---
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // --- State Jika Sukses ---
          final textContent = snapshot.data ?? 'Konten tidak tersedia.';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              textContent,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontFamily: 'serif',
              ),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../models/product.dart';
// import '../../config/config.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class ReaderScreen extends StatefulWidget {
//   final Product product;
//   const ReaderScreen({super.key, required this.product});

//   @override
//   State<ReaderScreen> createState() => _ReaderScreenState();
// }

// class _ReaderScreenState extends State<ReaderScreen> {
//   String? _fileUrl;
//   bool _isLoading = true;
//   String? _errorMessage;
//   String? _textContent;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFileUrl();
//   }

//   Future<void> _initializeFileUrl() async {
//     try {
//       final fileName = widget.product.file;
//       if (fileName.isEmpty) throw Exception('Nama file kosong di database.');

//       const bucketName = 'filebooks';
//       // karena bucket sudah public, cukup getPublicUrl
//       final publicUrl = Supabase.instance.client.storage
//           .from(bucketName)
//           .getPublicUrl(fileName);

//       setState(() {
//         _fileUrl = publicUrl;
//         _isLoading = false;
//       });

//       // jika ekstensi .txt, langsung load teksnya
//       if (fileName.toLowerCase().endsWith('.txt')) {
//         _loadText(publicUrl);
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Gagal membuat URL: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadText(String url) async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     try {
//       final res = await http.get(Uri.parse(url));
//       if (res.statusCode == 200) {
//         setState(() {
//           _textContent = res.body;
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('HTTP ${res.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Gagal memuat teks: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fileName = widget.product.file.toLowerCase();
//     final isTxt = fileName.endsWith('.txt');
//     final isPdf = fileName.endsWith('.pdf');

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.product.judul)),
//       body: Center(
//         child:
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : _errorMessage != null
//                 // Tampilkan error jika ada
//                 ? Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: SelectableText(
//                     _errorMessage!,
//                     style: const TextStyle(color: AppColors.error),
//                   ),
//                 )
//                 : isTxt
//                 // Tampilkan teks
//                 ? _textContent != null
//                     ? SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         _textContent!,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     )
//                     : const Text('Tidak ada konten.')
//                 : isPdf
//                 // Jika PDF, tampilkan dengan PDFViewer
//                 ? SizedBox.expand(
//                   child: SfPdfViewer.network(
//                     _fileUrl!,
//                     onDocumentLoadFailed: (details) {
//                       setState(() {
//                         _errorMessage = 'Gagal memuat PDF: ${details.error}';
//                       });
//                     },
//                   ),
//                 )
//                 : const Text('Format file tidak didukung.'),
//       ),
//     );
//   }
// }
