import 'package:apk_wisata/screens/penginapan_detail_screen.dart';
import 'package:apk_wisata/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/penginapan_model.dart';

class PenginapanListScreen extends StatefulWidget {
  const PenginapanListScreen({super.key});

  @override
  State<PenginapanListScreen> createState() => _PenginapanListScreenState();
}

class _PenginapanListScreenState extends State<PenginapanListScreen> {
  List<Penginapan> _penginapanList = [];
  List<Penginapan> _filteredPenginapan = [];
  Set<String> _favoriteIds = Set<String>();
  Set<String> _kotaList = Set<String>();
  String? _selectedKota;
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchPenginapan();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favorite_penginapan')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
      prefs.setStringList('favorite_penginapan', _favoriteIds.toList());
    });
  }

  Future<void> _fetchPenginapan() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getPenginapanList();
      setState(() {
        _penginapanList = data;
        _kotaList = data.map((e) => e.kota).toSet();
        _applyFilter();
      });
    } catch (e) {
      debugPrint('Gagal memuat data penginapan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data penginapan')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    List<Penginapan> result = _penginapanList;

    if (_selectedKota != null) {
      result = result.where((p) => p.kota == _selectedKota).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((p) =>
              p.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredPenginapan = result;
    });
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // 🔍 Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari penginapan...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _searchQuery = value;
              _applyFilter();
            },
          ),
          const SizedBox(height: 8),
          // 📍 Kota filter
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Pilih Kota',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            isExpanded: true,
            value: _selectedKota,
            items: [
              const DropdownMenuItem(value: null, child: Text('Semua')),
              ..._kotaList.map((k) => DropdownMenuItem(value: k, child: Text(k))),
            ],
            onChanged: (value) {
              setState(() {
                _selectedKota = value;
                _applyFilter();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Penginapan p) {
    final isFavorite = _favoriteIds.contains(p.id.toString());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            p.urlGambar,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(
          p.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${p.kota} • ${p.rating} ⭐\n${p.tipe} - ${p.harga}/malam',
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => _toggleFavorite(p.id.toString()),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PenginapanDetailScreen(penginapan: p),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchPenginapan,
        child: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredPenginapan.isEmpty
                      ? const Center(child: Text('Data tidak tersedia'))
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredPenginapan.length,
                          itemBuilder: (context, index) {
                            return _buildItem(_filteredPenginapan[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
