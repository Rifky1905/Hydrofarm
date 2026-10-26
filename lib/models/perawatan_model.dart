class Perawatan {
  Perawatan({
    required this.id,
    required this.tanamanId,
    required this.namaTanaman,
    required this.jenisPerawatan,
    required this.tanggal,
    required this.status,
    this.catatan = '',
  });

  final String id;
  final String tanamanId;
  String namaTanaman;
  String jenisPerawatan;
  DateTime tanggal;
  String status;
  String catatan;
}
