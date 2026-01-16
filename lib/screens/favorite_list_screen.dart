import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wisata_model.dart';
import '../models/restoran_model.dart';
import '../models/penginapan_model.dart';
import '../screens/wisata_detail_screen.dart';
import '../screens/restoran_detail_screen.dart';
import '../screens/penginapan_detail_screen.dart';
import '../services/api_service.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Wisata> _favoriteWisata = [];
  List<Restoran> _favoriteRestoran = [];
  List<Penginapan> _favoritePenginapan = [];

  bool _isLoadingWisata = false;
  bool _isLoadingRestoran = false;
  bool _isLoadingPenginapan = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await Future.wait([
      _loadWisataFavorites(),
      _loadRestoranFavorites(),
      _loadPenginapanFavorites(),
    ]);
  }

  Future<void> _loadWisataFavorites() async {
    setState(() => _isLoadingWisata = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList('favorites') ?? [];
      final allWisata = await ApiService.getWisataList();
      setState(() {
        _favoriteWisata =
            allWisata.where((w) => favIds.contains(w.id.toString())).toList();
      });
    } catch (e) {
      debugPrint('Gagal memuat wisata favorit: $e');
    } finally {
      setState(() => _isLoadingWisata = false);
    }
  }

  Future<void> _loadRestoranFavorites() async {
    setState(() => _isLoadingRestoran = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList('favorite_restoran_ids') ?? [];
      final allRestoran = await ApiService.getRestoranList();
      setState(() {
        _favoriteRestoran =
            allRestoran
                .where((r) => favIds.contains(r.idRestoran.toString()))
                .toList();
      });
    } catch (e) {
      debugPrint('Gagal memuat restoran favorit: $e');
    } finally {
      setState(() => _isLoadingRestoran = false);
    }
  }

  Future<void> _loadPenginapanFavorites() async {
    setState(() => _isLoadingPenginapan = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList('favorite_penginapan') ?? [];
      final allPenginapan = await ApiService.getPenginapanList();
      setState(() {
        _favoritePenginapan =
            allPenginapan
                .where((p) => favIds.contains(p.id.toString()))
                .toList();
      });
    } catch (e) {
      debugPrint('Gagal memuat penginapan favorit: $e');
    } finally {
      setState(() => _isLoadingPenginapan = false);
    }
  }

  Widget buildTile({
    required String imageUrl,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.broken_image, size: 40),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTabContent<T>({
    required bool isLoading,
    required List<T> items,
    required Future<void> Function() onRefresh,
    required Widget Function(T) buildItem,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => buildItem(items[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  bottom: TabBar(
    controller: _tabController,
    labelColor: Colors.white,             // warna teks tab yang aktif
    unselectedLabelColor: Colors.white70, // warna teks tab yang tidak aktif
    indicatorColor: Colors.white,         // warna garis bawah tab aktif
    tabs: const [
      Tab(text: 'Wisata'),
      Tab(text: 'Restoran'),
      Tab(text: 'Penginapan'),
    ],
  ),
),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent<Wisata>(
            isLoading: _isLoadingWisata,
            items: _favoriteWisata,
            onRefresh: _loadWisataFavorites,
            emptyMessage: 'Belum ada wisata favorit',
            buildItem:
                (w) => buildTile(
                  imageUrl: w.urlGambar,
                  title: w.nama,
                  subtitle: '${w.kabupatenKota} • ${w.rating} ⭐',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WisataDetailScreen(wisata: w),
                      ),
                    );
                  },
                ),
          ),
          _buildTabContent<Restoran>(
            isLoading: _isLoadingRestoran,
            items: _favoriteRestoran,
            onRefresh: _loadRestoranFavorites,
            emptyMessage: 'Belum ada restoran favorit',
            buildItem:
                (r) => buildTile(
                  imageUrl: r.urlGambar,
                  title: r.namaRestoran,
                  subtitle:
                      '${r.kabupatenKota} • ${r.rating.toStringAsFixed(1)} ⭐',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestoranDetailScreen(restoran: r),
                      ),
                    );
                  },
                ),
          ),
          _buildTabContent<Penginapan>(
            isLoading: _isLoadingPenginapan,
            items: _favoritePenginapan,
            onRefresh: _loadPenginapanFavorites,
            emptyMessage: 'Belum ada penginapan favorit',
            buildItem:
                (p) => buildTile(
                  imageUrl: p.urlGambar,
                  title: p.nama,
                  subtitle:
                      '${p.kota} • ${p.rating} ⭐\n${p.tipe} - ${p.harga}/mlm',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PenginapanDetailScreen(penginapan: p),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
