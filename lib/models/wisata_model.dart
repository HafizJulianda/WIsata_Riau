class Wisata {
  int id;
  String nama;
  String deskripsi;
  String alamat;
  String jamBuka;
  String kabupatenKota;
  double rating;
  String urlGambar;
  String urlAlamat;

  Wisata({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    required this.jamBuka,
    required this.kabupatenKota,
    required this.rating,
    required this.urlGambar,
    required this.urlAlamat,
  });

  factory Wisata.fromJson(Map<String, dynamic> json) {
    return Wisata(
      id: json['id_wisata'],
      nama: json['nama_wisata'],
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      jamBuka: json['jam_buka'],
      kabupatenKota: json['kabupaten_kota'],
      rating: double.parse(json['rating'].toString()),
      urlGambar: json['url_gambar'],
      urlAlamat: json['url_alamat'],
    );
  }
}
