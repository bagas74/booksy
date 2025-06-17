import 'product.dart'; // Import model Product

/// Represents a borrowing transaction record.
class Peminjaman {
  final String id;
  final Product buku; // Kita akan menyimpan seluruh objek Product di sini
  final DateTime tanggalPinjam;
  final DateTime batasWaktu;
  final DateTime? tanggalKembali;

  Peminjaman({
    required this.id,
    required this.buku,
    required this.tanggalPinjam,
    required this.batasWaktu,
    this.tanggalKembali,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      // 'buku' adalah nama tabel yang kita join dari Supabase
      buku: Product.fromJson(json['buku']),
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      batasWaktu: DateTime.parse(json['batas_waktu']),
      tanggalKembali:
          json['tanggal_kembali'] == null
              ? null
              : DateTime.parse(json['tanggal_kembali']),
    );
  }
}
