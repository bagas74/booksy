import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/buku..dart';

class BukuService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Buku>> fetchBuku() async {
    final response = await http.get(Uri.parse('$baseUrl/bukus'));
    final data = json.decode(response.body) as List;
    return data.map((e) => Buku.fromJson(e)).toList();
  }

  static Future<void> tambahBuku(Buku buku) async {
    await http.post(Uri.parse('$baseUrl/bukus'), body: buku.toJson());
  }

  static Future<void> updateBuku(int id, Buku buku) async {
    await http.put(Uri.parse('$baseUrl/bukus/$id'), body: buku.toJson());
  }

  static Future<void> deleteBuku(int id) async {
    await http.delete(Uri.parse('$baseUrl/bukus/$id'));
  }
}
