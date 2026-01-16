import 'package:flutter/material.dart';
import '../models/wisata_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WisataDetailScreen extends StatelessWidget {
  final Wisata wisata;

  const WisataDetailScreen({Key? key, required this.wisata}) : super(key: key);

  void _launchMap(BuildContext context) async {
    final Uri uri = Uri.parse(wisata.urlAlamat);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka link lokasi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green[700],
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      wisata.urlGambar,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    wisata.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wisata.kabupatenKota,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Bagian konten bawah
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          '${wisata.rating} / 5',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          wisata.deskripsi,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    // Tombol Maps
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _launchMap(context),
                        icon: const Icon(Icons.map),
                        label: const Text('Lihat Lokasi di Maps'),
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
          ],
        ),
      ),
    );
  }
}
