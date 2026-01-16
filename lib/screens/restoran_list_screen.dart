import 'package:apk_wisata/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restoran_model.dart';
import 'restoran_detail_screen.dart';

class RestoranListScreen extends StatefulWidget {
  @override
  _RestoranListScreenState createState() => _RestoranListScreenState();
}

class _RestoranListScreenState extends State<RestoranListScreen> {
  List<Restoran> _allRestoran = [];
  List<Restoran> _filteredRestoran = [];
  Set<String> _kabupatenSet = {};
  String? _selectedKabupaten;
  Set<String> _favoriteIds = Set<String>();
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchRestoran();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds =
          prefs.getStringList('favorite_restoran_ids')?.toSet() ?? {};
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
      prefs.setStringList('favorite_restoran_ids', _favoriteIds.toList());
    });
  }

  Future<void> _fetchRestoran() async {
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.getRestoranList();
      setState(() {
        _allRestoran = data;
        _kabupatenSet = data.map((r) => r.kabupatenKota).toSet();
        _applyFilter();
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data restoran')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    List<Restoran> result;

    if (_selectedKabupaten == null || _selectedKabupaten == 'Semua') {
      result = [..._allRestoran];
    } else {
      result = _allRestoran
          .where((r) => r.kabupatenKota == _selectedKabupaten)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((r) => r.namaRestoran
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredRestoran = result;
    });
  }

  Widget _buildItem(Restoran restoran) {
    final isFavorite = _favoriteIds.contains(restoran.idRestoran.toString());

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            restoran.urlGambar,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: Icon(Icons.restaurant, color: Colors.grey[600]),
            ),
          ),
        ),
        title: Text(
          restoran.namaRestoran,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${restoran.tipe} • Rp${restoran.harga}'),
            Text('${restoran.kabupatenKota} • ${restoran.jarak}'),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(restoran.jamOperasional),
                Spacer(),
                Icon(Icons.star, size: 14, color: Colors.amber),
                Text(' ${restoran.rating.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => _toggleFavorite(restoran.idRestoran.toString()),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestoranDetailScreen(restoran: restoran),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilter();
              },
            ),
          ),

          // 📍 Dropdown filter kabupaten
        if (_kabupatenSet.isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Pilih Kabupaten/Kota',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: _selectedKabupaten,
      items: [
        const DropdownMenuItem(value: 'Semua', child: Text('Semua')),
        ..._kabupatenSet.map((kab) => DropdownMenuItem(value: kab, child: Text(kab))),
      ],
      onChanged: (value) {
        _selectedKabupaten = value == 'Semua' ? null : value;
        _applyFilter();
      },
    ),
  ),

          // 📄 Daftar restoran
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRestoran,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredRestoran.isEmpty
                      ? Center(child: Text('Data tidak tersedia'))
                      : ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredRestoran.length,
                          itemBuilder: (context, index) {
                            return _buildItem(_filteredRestoran[index]);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
