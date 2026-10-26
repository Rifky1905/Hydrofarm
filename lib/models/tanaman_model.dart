class Tanaman {
  Tanaman({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggalTanam,
    required this.umurPanen,
    required this.status,
  });

  final String id;
  String nama;
  String jenis;
  DateTime tanggalTanam;

  /// Perkiraan umur tanaman hingga siap panen (dalam hari).
  int umurPanen;
  String status;

  /// Perkiraan tanggal panen = tanggal tanam + umur panen.
  DateTime get estimasiPanen => tanggalTanam.add(Duration(days: umurPanen));

  /// Konversi objek ke JSON untuk disimpan ke Supabase.
  /// Nama kolom mengikuti konvensi snake_case di tabel `tanaman`.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'tanggal_tanam': tanggalTanam.toIso8601String().split('T').first,
      'umur_panen': umurPanen,
      'status': status,
    };
  }

  /// Konversi baris hasil query Supabase menjadi objek Tanaman.
  factory Tanaman.fromJson(Map<String, dynamic> json) {
    return Tanaman(
      id: json['id'] as String,
      nama: json['nama'] as String,
      jenis: json['jenis'] as String,
      tanggalTanam: DateTime.parse(json['tanggal_tanam'] as String),
      umurPanen: json['umur_panen'] as int,
      status: json['status'] as String,
    );
  }
}
