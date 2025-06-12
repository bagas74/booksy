import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/product.dart';
import '../../config/config.dart';

class ReaderScreen extends StatefulWidget {
  final Product product;
  const ReaderScreen({super.key, required this.product});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String? _pdfUrl;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePdfUrl();
  }

  void _initializePdfUrl() {
    try {
      // Kita akan coba bangun URL secara dinamis (Praktik Terbaik)
      final String fileName = widget.product.file;
      if (fileName.isEmpty) {
        throw Exception('Nama file kosong di database.');
      }

      // --- PERBAIKAN DI SINI ---
      // Nama bucket disesuaikan dengan screenshot Anda
      const String pdfBucketName = 'filebooks';

      final String publicUrl = Supabase.instance.client.storage
          .from(pdfBucketName)
          .getPublicUrl(fileName);

      // --- BAGIAN DEBUGGING ---
      // Ini akan mencetak URL lengkap ke konsol debug Anda
      debugPrint('--- PDF URL DEBUG ---');
      debugPrint('Nama File dari DB: $fileName');
      debugPrint('URL yang Dibangun: $publicUrl');
      debugPrint('---------------------');
      // -----------------------

      setState(() {
        _pdfUrl = publicUrl;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Gagal membuat URL: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.judul)),
      body: Center(child: _buildPdfViewer()),
    );
  }

  Widget _buildPdfViewer() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }
    if (_errorMessage != null) {
      // Tampilkan error dan URL yang gagal dimuat
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          'Error: $_errorMessage\n\nURL yang dicoba: $_pdfUrl',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }
    if (_pdfUrl != null) {
      return SfPdfViewer.network(
        _pdfUrl!,
        onDocumentLoadFailed: (details) {
          setState(() {
            _errorMessage =
                'Gagal memuat PDF dari URL. Detail: ${details.error} - ${details.description}';
          });
        },
      );
    }
    return const Text('Terjadi kesalahan tidak terduga.');
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
