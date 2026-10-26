import 'package:flutter_test/flutter_test.dart';
import 'package:hydrofarm/models/tanaman_model.dart';

void main() {
  test('estimasiPanen = tanggalTanam + umurPanen', () {
    final tanaman = Tanaman(
      id: 'T001',
      nama: 'Selada',
      jenis: 'Sayuran Daun',
      tanggalTanam: DateTime(2026, 1, 1),
      umurPanen: 30,
      status: 'Tumbuh',
    );

    expect(tanaman.estimasiPanen, DateTime(2026, 1, 31));
  });
}
