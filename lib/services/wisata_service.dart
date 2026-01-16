import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wisata_model.dart';

class WisataService {
  static const String baseUrl =
      'https://e29b0ec8f7c4.ngrok-free.app/api'; // ganti sesuai IP backend

  static Future<List<Wisata>> getWisataList() async {
    final response = await http.get(Uri.parse('$baseUrl/wisata'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Wisata.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<List<Wisata>> getPaginatedWisata(int page, int limit) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wisata?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data']; // pakai Laravel pagination

      return data.map((item) => Wisata.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data. Status: ${response.statusCode}');
    }
  }
}
