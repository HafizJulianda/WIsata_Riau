import 'package:flutter/material.dart';
import '../models/penginapan_model.dart';

class PenginapanDetailScreen extends StatelessWidget {
  final Penginapan penginapan;

  const PenginapanDetailScreen({super.key, required this.penginapan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(penginapan.nama),
        backgroundColor: Colors.green[700],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan gambar dan tombol kembali
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.green[700],
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      penginapan.urlGambar,
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
                    penginapan.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    penginapan.kota,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Detail info di bawah
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
                          '${penginapan.rating} / 5',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Info lainnya
                    Text(
                      'Tipe: ${penginapan.tipe}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Harga: Rp${penginapan.harga}/malam',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Deskripsi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Penginapan nyaman dan strategis untuk liburan maupun perjalanan bisnis. Fasilitas lengkap dan pelayanan ramah siap menyambut Anda.',
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