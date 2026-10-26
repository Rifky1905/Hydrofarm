import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tanaman_model.dart';

/// Facade akses data tanaman.
///
/// Jika kredensial Supabase sudah diisi di [SupabaseConfig] dan inisialisasi
/// berhasil (lihat main.dart), data disimpan permanen di database Supabase —
/// bekerja di semua platform termasuk Web.
///
/// Jika belum dikonfigurasi, otomatis fallback ke penyimpanan in-memory
/// (data hilang saat restart) agar aplikasi tetap bisa dijalankan.
class TanamanService {
  TanamanService._();

  /// Di-set true dari main.dart setelah Supabase.initialize() berhasil.
  static bool useRemote = false;

  static const String _table = 'tanaman';
  static SupabaseClient get _client => Supabase.instance.client;

  // Fallback in-memory saat Supabase belum dikonfigurasi.
  static final List<Tanaman> _memoryItems = [
    Tanaman(
      id: 'T001',
      nama: 'Selada Romaine',
      jenis: 'Sayuran Daun',
      tanggalTanam: DateTime.now().subtract(const Duration(days: 20)),
      umurPanen: 30,
      status: 'Tumbuh',
    ),
    Tanaman(
      id: 'T002',
      nama: 'Kangkung',
      jenis: 'Sayuran Daun',
      tanggalTanam: DateTime.now().subtract(const Duration(days: 25)),
      umurPanen: 25,
      status: 'Siap Panen',
    ),
    Tanaman(
      id: 'T003',
      nama: 'Pakcoy',
      jenis: 'Sayuran Daun',
      tanggalTanam: DateTime.now().subtract(const Duration(days: 10)),
      umurPanen: 40,
      status: 'Tumbuh',
    ),
    Tanaman(
      id: 'T004',
      nama: 'Bayam Hijau',
      jenis: 'Sayuran Daun',
      tanggalTanam: DateTime.now().subtract(const Duration(days: 15)),
      umurPanen: 25,
      status: 'Tumbuh',
    ),
    Tanaman(
      id: 'T005',
      nama: 'Tomat Ceri',
      jenis: 'Sayuran Buah',
      tanggalTanam: DateTime.now().subtract(const Duration(days: 45)),
      umurPanen: 70,
      status: 'Berbunga',
    ),
  ];

  /// Jika request Supabase gagal (server down / tidak bisa dijangkau),
  /// operasi tetap dijalankan di memori agar aplikasi tidak macet.
  static Future<List<Tanaman>> getAll() async {
    if (useRemote) {
      try {
        final rows = await _client.from(_table).select().order('id');
        return rows.map(Tanaman.fromJson).toList();
      } catch (e) {
        debugPrint('Supabase getAll gagal, pakai memori: $e');
      }
    }
    return List.unmodifiable(_memoryItems);
  }

  static Future<void> add(Tanaman tanaman) async {
    if (useRemote) {
      try {
        return await _client.from(_table).insert(tanaman.toJson());
      } catch (e) {
        debugPrint('Supabase insert gagal, simpan ke memori: $e');
      }
    }
    _memoryItems.add(tanaman);
  }

  static Future<void> update(Tanaman tanaman) async {
    if (useRemote) {
      try {
        return await _client
            .from(_table)
            .update(tanaman.toJson())
            .eq('id', tanaman.id);
      } catch (e) {
        debugPrint('Supabase update gagal, simpan ke memori: $e');
      }
    }
    // Objek dimutasi langsung di halaman update, tidak perlu aksi tambahan.
  }

  static Future<void> delete(String id) async {
    if (useRemote) {
      try {
        return await _client.from(_table).delete().eq('id', id);
      } catch (e) {
        debugPrint('Supabase delete gagal, hapus dari memori: $e');
      }
    }
    _memoryItems.removeWhere((t) => t.id == id);
  }

  static Future<String> nextId() async {
    if (useRemote) {
      try {
        final rows = await _client.from(_table).select('id');
        return 'T${(rows.length + 1).toString().padLeft(3, '0')}';
      } catch (e) {
        debugPrint('Supabase nextId gagal, pakai memori: $e');
      }
    }
    return 'T${(_memoryItems.length + 1).toString().padLeft(3, '0')}';
  }
}

/// Format tanggal ke bentuk DD/MM/YYYY.
String formatTanggal(DateTime date) => '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/'
    '${date.year}';
