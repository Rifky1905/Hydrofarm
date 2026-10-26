import 'package:flutter/material.dart';

import '../models/tanaman_model.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';
import 'perawatan_insert.dart';
import 'tanaman_update.dart';

class TanamanDetail extends StatefulWidget {
  const TanamanDetail({super.key, required this.tanaman});

  final Tanaman tanaman;

  @override
  State<TanamanDetail> createState() => _TanamanDetailState();
}

class _TanamanDetailState extends State<TanamanDetail> {
  Future<void> _openEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TanamanUpdate(tanaman: widget.tanaman),
      ),
    );
    setState(() {}); // refresh tampilan setelah edit
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: Text('Hapus data "${widget.tanaman.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await TanamanService.delete(widget.tanaman.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanaman = widget.tanaman;
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Text(tanaman.nama),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: _openEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.eco, size: 56, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              tanaman.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _DetailRow(label: 'ID Tanaman', value: tanaman.id),
                    _DetailRow(label: 'Jenis', value: tanaman.jenis),
                    _DetailRow(
                      label: 'Tanggal Tanam',
                      value: formatTanggal(tanaman.tanggalTanam),
                    ),
                    _DetailRow(
                      label: 'Umur Panen',
                      value: '${tanaman.umurPanen} hari',
                    ),
                    _DetailRow(
                      label: 'Estimasi Panen',
                      value: formatTanggal(tanaman.estimasiPanen),
                    ),
                    _DetailRow(label: 'Status', value: tanaman.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerawatanInsert(tanaman: tanaman),
                  ),
                ),
                icon: const Icon(Icons.add_task),
                label: const Text(
                  'Jadwalkan Perawatan',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
