class Penginapan {
  final int id;
  final String nama;
  final String deskripsi;
  final String tipe;
  final String fasilitas;
  final String harga;
  final String alamat;
  final String kota;
  final String jarak;
  final double rating;
  final String urlGambar;

  Penginapan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.tipe,
    required this.fasilitas,
    required this.harga,
    required this.alamat,
    required this.kota,
    required this.jarak,
    required this.rating,
    required this.urlGambar,
  });

  factory Penginapan.fromJson(Map<String, dynamic> json) {
    return Penginapan(
      id: json['id_penginapan'],
      nama: json['nama_penginapan'],
      deskripsi: json['deskripsi_singkat'],
      tipe: json['tipe'],
      fasilitas: json['fasilitas'],
      harga: json['harga_per_malam'],
      alamat: json['alamat'],
      kota: json['kota_kabupaten'],
      jarak: json['jarak_ke_wisata'],
      rating: (json['rating'] as num).toDouble(),
      urlGambar: json['url_gambar'],
    );
  }
}
