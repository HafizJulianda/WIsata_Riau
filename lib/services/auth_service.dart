import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // ganti dengan IP lokal/server kamu

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'username': username,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }
}
