import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pengguna_model.dart';
import '../models/restoran_model.dart';
import '../models/wisata_model.dart';
import '../models/penginapan_model.dart';

class ApiService {
  /// Ganti ke IP lokal atau domain jika sudah produksi
  static const String baseUrl = 'https://e29b0ec8f7c4.ngrok-free.app/api';

  // ==================== LOGIN PENGGUNA ====================
  static Future<Pengguna> loginPengguna({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('Login status code: ${response.statusCode}');
    print('Login response: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['user'] != null) {
        return Pengguna.fromJson(body['user']);
      } else {
        throw Exception('❌ Field "user" tidak ditemukan dalam response.');
      }
    } else {
      throw Exception('❌ Login gagal: ${response.body}');
    }
  }

  // ==================== REGISTER PENGGUNA ====================
  static Future<Pengguna> registerPengguna({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('Register status code: ${response.statusCode}');
    print('Register response: ${response.body}');

    if (response.statusCode == 201) {
      final body = json.decode(response.body);
      if (body['data'] != null) {
        return Pengguna.fromJson(body['data']);
      } else {
        throw Exception('❌ Field "data" tidak ditemukan dalam response.');
      }
    } else {
      throw Exception('❌ Registrasi gagal: ${response.body}');
    }
  }

  // ========== GANTI PASSWORD DENGAN PASSWORD LAMA ==========
  static Future<void> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    print('Change Password status: ${response.statusCode}');
    print('Change Password response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('❌ Gagal mengubah password: ${response.body}');
    }
  }

  // ========== GANTI PASSWORD TANPA PASSWORD LAMA ==========
  static Future<void> changePasswordWithoutOld({
    required String username,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password-no-old'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'new_password': newPassword,
      }),
    );

    print('Change Password (no old) status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('❌ Gagal mengubah password tanpa old: ${response.body}');
    }
  }

  // ==================== DELETE ACCOUNT ====================
  static Future<void> deleteAccount({
    required String username,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete-account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
      }),
    );

    print('Delete Account status: ${response.statusCode}');
    print('Delete Account response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('❌ Gagal menghapus akun: ${response.body}');
    }
  }

  // ==================== GET DATA RESTORAN ====================
  static Future<List<Restoran>> getRestoranList() async {
    return _getDataList<Restoran>(
      endpoint: 'restoran',
      fromJson: Restoran.fromJson,
    );
  }

  // ==================== GET DATA WISATA ====================
  static Future<List<Wisata>> getWisataList() async {
    return _getDataList<Wisata>(
      endpoint: 'wisata',
      fromJson: Wisata.fromJson,
    );
  }

  // ==================== GET DATA PENGINAPAN ====================
  static Future<List<Penginapan>> getPenginapanList() async {
    return _getDataList<Penginapan>(
      endpoint: 'penginapan',
      fromJson: Penginapan.fromJson,
    );
  }

  // ==================== GENERIC GETTER ====================
  static Future<List<T>> _getDataList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    print('GET $endpoint status: ${response.statusCode}');
    print('GET $endpoint response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => fromJson(item)).toList();
    } else {
      throw Exception('❌ Gagal memuat data $endpoint: ${response.statusCode}');
    }
  }
}