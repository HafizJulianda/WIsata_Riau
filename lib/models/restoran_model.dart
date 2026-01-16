class Restoran {
  int idRestoran;
  String namaRestoran;
  String tipe;
  String alamat;
  String harga;
  String jamOperasional;
  String kabupatenKota;
  String jarak;
  double rating;
  String urlGambar;

  Restoran({
    required this.idRestoran,
    required this.namaRestoran,
    required this.tipe,
    required this.alamat,
    required this.harga,
    required this.jamOperasional,
    required this.kabupatenKota,
    required this.jarak,
    required this.rating,
    required this.urlGambar,
  });

  factory Restoran.fromJson(Map<String, dynamic> json) {
    return Restoran(
      idRestoran: int.parse(json['id_restoran'].toString()),
      namaRestoran: json['nama_restoran'] ?? '',
      tipe: json['tipe'] ?? '',
      alamat: json['alamat'] ?? '',
      harga:
          json['harga']?.toString() ??
          '0', // Handle null dan konversi ke String
      jamOperasional: json['jam_operasional'] ?? '',
      kabupatenKota: json['kabupaten_kota'] ?? '',
      jarak: json['jarak'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      urlGambar: json['url_gambar'] ?? '',
    );
  }
}
