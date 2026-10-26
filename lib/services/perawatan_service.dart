import '../models/perawatan_model.dart';

/// Penyimpanan data jadwal perawatan sementara (in-memory).
class PerawatanService {
  PerawatanService._();

  static final List<Perawatan> _items = [
    Perawatan(
      id: 'P001',
      tanamanId: 'T002',
      namaTanaman: 'Kangkung',
      jenisPerawatan: 'Penambahan Nutrisi',
      tanggal: DateTime.now().add(const Duration(days: 1)),
      status: 'Terjadwal',
      catatan: 'Cek TDS sebelum menambah nutrisi',
    ),
    Perawatan(
      id: 'P002',
      tanamanId: 'T001',
      namaTanaman: 'Selada Romaine',
      jenisPerawatan: 'Cek pH & TDS',
      tanggal: DateTime.now(),
      status: 'Selesai',
    ),
    Perawatan(
      id: 'P003',
      tanamanId: 'T005',
      namaTanaman: 'Tomat Ceri',
      jenisPerawatan: 'Pemangkasan',
      tanggal: DateTime.now().add(const Duration(days: 3)),
      status: 'Terjadwal',
    ),
  ];

  static List<Perawatan> getAll() => List.unmodifiable(_items);

  static void add(Perawatan perawatan) => _items.add(perawatan);

  static void delete(String id) => _items.removeWhere((p) => p.id == id);

  /// Ubah status Terjadwal <-> Selesai.
  static void toggleStatus(String id) {
    final item = _items.firstWhere((p) => p.id == id);
    item.status = item.status == 'Selesai' ? 'Terjadwal' : 'Selesai';
  }

  static String nextId() =>
      'P${(_items.length + 1).toString().padLeft(3, '0')}';
}
