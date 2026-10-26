import 'package:flutter/material.dart';

import '../models/perawatan_model.dart';
import '../models/tanaman_model.dart';
import '../services/perawatan_service.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';

class PerawatanInsert extends StatefulWidget {
  const PerawatanInsert({super.key, this.tanaman});

  /// Jika diisi, dropdown tanaman langsung terpilih ke tanaman ini.
  final Tanaman? tanaman;

  @override
  State<PerawatanInsert> createState() => _PerawatanInsertState();
}

class _PerawatanInsertState extends State<PerawatanInsert> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _catatanController = TextEditingController();

  static const List<String> _jenisOptions = [
    'Penambahan Nutrisi',
    'Pergantian Air',
    'Pembersihan Sistem',
    'Cek pH & TDS',
    'Pemangkasan',
    'Lainnya',
  ];

  String? _selectedTanamanId;
  String _jenis = _jenisOptions.first;
  DateTime? _tanggal;

  List<Tanaman> _tanamanList = [];

  @override
  void initState() {
    super.initState();
    _selectedTanamanId = widget.tanaman?.id;
    _loadTanaman();
  }

  Future<void> _loadTanaman() async {
    final data = await TanamanService.getAll();
    setState(() => _tanamanList = data);
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _tanggalController.text = formatTanggal(picked); // DD/MM/YYYY
      });
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih tanggal perawatan terlebih dahulu')),
      );
      return;
    }

    final tanaman = _tanamanList.firstWhere((t) => t.id == _selectedTanamanId);
    final perawatanBaru = Perawatan(
      id: PerawatanService.nextId(),
      tanamanId: tanaman.id,
      namaTanaman: tanaman.nama,
      jenisPerawatan: _jenis,
      tanggal: _tanggal!,
      status: 'Terjadwal',
      catatan: _catatanController.text.trim(),
    );
    PerawatanService.add(perawatanBaru);
    Navigator.pop(context, perawatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Tambah Perawatan'),
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
              DropdownButtonFormField<String>(
                initialValue: _selectedTanamanId,
                decoration: const InputDecoration(
                  labelText: 'Pilih Tanaman',
                  prefixIcon: Icon(Icons.eco_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _tanamanList
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.nama),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedTanamanId = value),
                validator: (value) =>
                    value == null ? 'Pilih tanaman terlebih dahulu' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _jenis,
                decoration: const InputDecoration(
                  labelText: 'Jenis Perawatan',
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
                  labelText: 'Tanggal Perawatan (DD/MM/YYYY)',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _tanggal == null
                    ? 'Tanggal perawatan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
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
