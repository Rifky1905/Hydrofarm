import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tanaman_model.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';

class TanamanUpdate extends StatefulWidget {
  const TanamanUpdate({super.key, required this.tanaman});

  final Tanaman tanaman;

  @override
  State<TanamanUpdate> createState() => _TanamanUpdateState();
}

class _TanamanUpdateState extends State<TanamanUpdate> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _umurPanenController;
  late final TextEditingController _tanggalController;

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

  late String _jenis;
  late String _status;
  DateTime? _tanggalTanam;

  @override
  void initState() {
    super.initState();
    final t = widget.tanaman;
    _namaController = TextEditingController(text: t.nama);
    _umurPanenController = TextEditingController(text: '${t.umurPanen}');
    _tanggalController = TextEditingController(
      text: formatTanggal(t.tanggalTanam),
    );
    _jenis = _jenisOptions.contains(t.jenis) ? t.jenis : _jenisOptions.first;
    _status =
        _statusOptions.contains(t.status) ? t.status : _statusOptions.first;
    _tanggalTanam = t.tanggalTanam;
  }

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

    final t = widget.tanaman;
    t.nama = _namaController.text.trim();
    t.jenis = _jenis;
    t.tanggalTanam = _tanggalTanam!;
    t.umurPanen = int.parse(_umurPanenController.text);
    t.status = _status;
    await TanamanService.update(t);
    if (mounted) Navigator.pop(context, t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Edit Tanaman'),
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
                label: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontSize: 16),
                ),
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
