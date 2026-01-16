import 'package:apk_wisata/screens/wisata_detail_screen.dart';
import 'package:apk_wisata/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wisata_model.dart';

class WisataListScreen extends StatefulWidget {
  @override
  _WisataListScreenState createState() => _WisataListScreenState();
}

class _WisataListScreenState extends State<WisataListScreen> {
  List<Wisata> _wisataList = [];
  List<Wisata> _filteredWisata = [];
  Set<String> _favoriteIds = Set<String>();
  Set<String> _kabupatenList = Set<String>();
  String? _selectedKabupaten;

  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchWisata();
  }

  Future<void> _fetchWisata() async {
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.getWisataList();
      setState(() {
        _wisataList = data;
        _kabupatenList = data.map((e) => e.kabupatenKota).toSet();
        _applyFilter();
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    List<Wisata> filtered =
        _selectedKabupaten == null
            ? _wisataList
            : _wisataList
                .where((w) => w.kabupatenKota == _selectedKabupaten)
                .toList();

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (w) =>
                    w.nama.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    setState(() {
      _filteredWisata = filtered;
    });
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favorites')?.toSet() ?? {};
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
      prefs.setStringList('favorites', _favoriteIds.toList());
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari wisata...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          _searchQuery = value;
          _applyFilter();
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Pilih Kabupaten/Kota',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        isExpanded: true,
        value: _selectedKabupaten,
        items: [
          const DropdownMenuItem(value: null, child: Text('Semua')),
          ..._kabupatenList.map(
            (kab) => DropdownMenuItem(value: kab, child: Text(kab)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedKabupaten = value;
            _applyFilter();
          });
        },
      ),
    );
  }

  Widget _buildCardItem(Wisata wisata) {
    final isFavorite = _favoriteIds.contains(wisata.id.toString());

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WisataDetailScreen(wisata: wisata),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  wisata.urlGambar,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (c, e, s) => Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wisata.nama,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(wisata.kabupatenKota, style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: Colors.redAccent,
                ),
                onPressed: () => _toggleFavorite(wisata.id.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchWisata,
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterBar(),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredWisata.isEmpty
                      ? const Center(child: Text('Data tidak tersedia'))
                      : ListView.builder(
                        itemCount: _filteredWisata.length,
                        itemBuilder: (context, index) {
                          return _buildCardItem(_filteredWisata[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
