import 'package:flutter/material.dart';
import '../models/restoran_model.dart';

class RestoranDetailScreen extends StatelessWidget {
  final Restoran restoran;

  const RestoranDetailScreen({Key? key, required this.restoran})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(restoran.namaRestoran),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[700],
      body: SafeArea(
        child: Column(
          children: [
            // Bagian header dengan gambar, nama restoran, dan tombol kembali
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green[700],
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(), // Optional, to move image to the center
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      restoran.urlGambar,
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
                    restoran.namaRestoran,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restoran.kabupatenKota,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Konten detail dalam container putih
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
                          '${restoran.rating.toStringAsFixed(1)} / 5',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Info lainnya
                    Text(
                      'Tipe: ${restoran.tipe}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Harga: ${restoran.harga}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Jarak: ${restoran.jarak}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Jam Operasional: ${restoran.jamOperasional}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Deskripsi (jika ada nanti bisa ditambah)
                    const Text(
                      'Nikmati sajian kuliner terbaik di tempat ini dengan kenyamanan dan suasana yang menyenangkan.',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.justify,
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
