import 'package:apk_wisata/screens/favorite_list_screen.dart';
import 'package:apk_wisata/screens/penginapan_list_screen.dart';
import 'package:apk_wisata/screens/restoran_list_screen.dart';
import 'package:apk_wisata/screens/wisata_list_screen.dart';
import 'package:apk_wisata/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar screen sesuai dengan bottom navigation
  final List<Widget> _screens = [
    WisataListScreen(),
    PenginapanListScreen(),
    RestoranListScreen(),
    FavoriteScreen(), // ✅ Tambahkan screen ke-4
  ];

  // Title untuk AppBar yang berubah sesuai tab
  String get _currentTitle {
    switch (_currentIndex) {
      case 0:
        return 'Wisata';
      case 1:
        return 'Penginapan';
      case 2:
        return 'Restoran';
      case 3:
        return 'Favorit';
      default:
        return 'Aplikasi Wisata';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color.fromARGB(255, 184, 212, 22),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromARGB(255, 184, 212, 22),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Wisata'),
        BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Penginapan'),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Restoran',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorit',
        ),
      ],
    );
  }
}
