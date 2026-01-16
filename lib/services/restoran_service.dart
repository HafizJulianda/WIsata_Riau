import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restoran_model.dart';

class RestoranService {
  static const String baseUrl = 'https://8a23-182-1-5-32.ngrok-free.app/api';

  static Future<List<Restoran>> getRestoranList() async {
    final response = await http.get(Uri.parse('$baseUrl/restoran'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Restoran.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data restoran: ${response.statusCode}');
    }
  }

  static Future<List<Restoran>> getPaginatedRestoran(
    int page,
    int limit,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/restoran?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data']; // Sesuai pagination Laravel

      return data.map((item) => Restoran.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data. Status: ${response.statusCode}');
    }
  }
}
