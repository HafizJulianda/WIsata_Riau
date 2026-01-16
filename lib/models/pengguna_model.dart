class Pengguna {
  final int id;
  final String username;

  Pengguna({
    required this.id,
    required this.username,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}
