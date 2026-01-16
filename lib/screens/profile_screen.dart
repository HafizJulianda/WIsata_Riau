import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme_notifier.dart';
import '../utils/shared_pref_manager.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loggedIn = await SharedPrefManager.isLoggedIn();
    final uname = await SharedPrefManager.getUsername();

    setState(() {
      _isLoggedIn = loggedIn;
      _username = uname;
    });
  }

  void _logout() async {
    await SharedPrefManager.logout();
    setState(() {
      _isLoggedIn = false;
      _username = null;
    });
    Navigator.pushNamed(context, '/login');
  }

  void _goToLogin() => Navigator.pushNamed(context, '/login');
  void _goToRegister() => Navigator.pushNamed(context, '/register');

  void _launchContact(BuildContext context) async {
    final Uri waUrl = Uri.parse(
      'https://wa.me/6282268913239?text=Halo%2C%20saya%20tertarik%20dengan%20aplikasi%20Anda',
    );

    try {
      bool success = await launchUrl(
        waUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp tidak dapat dibuka')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan membuka WhatsApp')),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool _obscureNew = true;
    bool _obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Ubah Kata Sandi'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: newPasswordController,
                    obscureText: _obscureNew,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscureNew = !_obscureNew);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi Baru',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newPass = newPasswordController.text.trim();
                  final confirmPass = confirmPasswordController.text.trim();

                  if (newPass.isEmpty || confirmPass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semua kolom wajib diisi')),
                    );
                    return;
                  }

                  if (newPass != confirmPass) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Konfirmasi tidak cocok')),
                    );
                    return;
                  }

                  try {
                    final username = await SharedPrefManager.getUsername();
                    if (username == null) throw 'User tidak ditemukan';

                    await ApiService.changePasswordWithoutOld(
                      username: username,
                      newPassword: newPass,
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kata sandi berhasil diubah')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text('Apakah Anda yakin ingin menghapus akun Anda? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final username = await SharedPrefManager.getUsername();
                if (username == null) throw 'User tidak ditemukan';

                // Assuming ApiService has a deleteAccount method
                await ApiService.deleteAccount(username: username);
                
                await SharedPrefManager.logout();
                setState(() {
                  _isLoggedIn = false;
                  _username = null;
                });
                
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Akun berhasil dihapus')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus akun: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeNotifier.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/image.jpg'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isLoggedIn ? 'Pengguna' : 'Belum Login',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLoggedIn ? (_username ?? '') : 'Silakan login terlebih dahulu',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    if (_isLoggedIn)
                      Column(
                        children: [
                          SizedBox(
                            width: 160,
                            child: ElevatedButton.icon(
                              onPressed: _logout,
                              icon: const Icon(Icons.logout),
                              label: const Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 160,
                            child: OutlinedButton.icon(
                              onPressed: () => _showChangePasswordDialog(context),
                              icon: const Icon(Icons.lock_reset),
                              label: const Text("Ubah Password"),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 160,
                            child: OutlinedButton.icon(
                              onPressed: () => _showDeleteAccountDialog(context),
                              icon: const Icon(Icons.delete_forever),
                              label: const Text("Hapus Akun"),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red[600]!),
                                foregroundColor: Colors.red[600],
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _goToLogin,
                            child: const Text("Login"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _goToRegister,
                            child: const Text("Register"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tentang:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Jurusan Informatika adalah jurusan yang mempelajari tentang teknologi informasi, pemrograman, jaringan, dan pengembangan perangkat lunak untuk memecahkan masalah di dunia nyata.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchContact(context),
                  icon: const Icon(Icons.phone),
                  label: const Text('Hubungi Sekarang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}