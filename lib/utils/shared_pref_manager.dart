import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyUserId = 'userId';
  static const _keyUsername = 'username';

  // Simpan data pengguna setelah login / register
  static Future<void> saveUser({
    required int id,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setInt(_keyUserId, id);
    await prefs.setString(_keyUsername, username);
  }

  // Cek apakah pengguna sudah login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Ambil ID pengguna
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // Ambil username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Hapus semua data login
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
