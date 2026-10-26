import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tanaman_model.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';

class TanamanInsert extends StatefulWidget {
  const TanamanInsert({super.key});

  @override
  State<TanamanInsert> createState() => _TanamanInsertState();
}

class _TanamanInsertState extends State<TanamanInsert> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurPanenController = TextEditingController();
  final _tanggalController = TextEditingController();

  static const List<String> _jenisOptions = [
    'Sayuran Daun',
    'Sayuran Buah',
    'Herba',
    'Lainnya',
  ];
  static const List<String> _statusOptions = [
    'Tumbuh',
    'Berbunga',
    'Siap Panen',
    'Dipanen',
  ];

  String _jenis = _jenisOptions.first;
  String _status = _statusOptions.first;
  DateTime? _tanggalTanam;

  @override
  void dispose() {
    _namaController.dispose();
    _umurPanenController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTanam ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _tanggalTanam = picked;
        _tanggalController.text = formatTanggal(picked); // DD/MM/YYYY
      });
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggalTanam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal tanam terlebih dahulu')),
      );
      return;
    }

    try {
      final tanamanBaru = Tanaman(
        id: await TanamanService.nextId(),
        nama: _namaController.text.trim(),
        jenis: _jenis,
        tanggalTanam: _tanggalTanam!,
        umurPanen: int.parse(_umurPanenController.text),
        status: _status,
      );
      await TanamanService.add(tanamanBaru);
      if (mounted) Navigator.pop(context, tanamanBaru);
    } catch (e) {
      debugPrint('Gagal menyimpan tanaman: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan tanaman: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Tambah Tanaman'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Tanaman',
                  prefixIcon: Icon(Icons.eco_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama tanaman tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _jenis,
                decoration: const InputDecoration(
                  labelText: 'Jenis Tanaman',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _jenisOptions
                    .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                    .toList(),
                onChanged: (value) => setState(() => _jenis = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _pickTanggal,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Tanam (DD/MM/YYYY)',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _tanggalTanam == null
                    ? 'Tanggal tanam tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _umurPanenController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Umur Panen (hari)',
                  prefixIcon: Icon(Icons.schedule_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final umur = int.tryParse(value ?? '');
                  if (umur == null || umur <= 0) {
                    return 'Umur panen harus berupa angka lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.flag_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
