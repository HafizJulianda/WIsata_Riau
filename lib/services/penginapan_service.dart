import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penginapan_model.dart';

class PenginapanService {
  static const String baseUrl = ' https://721f-182-1-5-32.ngrok-free.app/api';

  static Future<List<Penginapan>> getPaginated(int page, int limit) async {
    final response = await http.get(
      Uri.parse('$baseUrl/penginapan?page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> data = jsonMap['data'];
      return data.map((item) => Penginapan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }
}
