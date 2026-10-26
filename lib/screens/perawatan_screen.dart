import 'package:flutter/material.dart';

import '../models/perawatan_model.dart';
import '../services/perawatan_service.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';
import 'monitoring_screen.dart';
import 'perawatan_insert.dart';

class PerawatanScreen extends StatefulWidget {
  const PerawatanScreen({super.key});

  @override
  State<PerawatanScreen> createState() => _PerawatanScreenState();
}

class _PerawatanScreenState extends State<PerawatanScreen> {
  List<Perawatan> get _perawatanList => PerawatanService.getAll();

  Future<void> _openInsert() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerawatanInsert()),
    );
    setState(() {}); // refresh setelah menambah data
  }

  Future<void> _confirmDelete(Perawatan perawatan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Perawatan'),
        content: Text(
          'Hapus jadwal "${perawatan.jenisPerawatan}" '
          'untuk ${perawatan.namaTanaman}?',
        ),
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
      setState(() => PerawatanService.delete(perawatan.id));
    }
  }

  IconData _jenisIcon(String jenis) {
    switch (jenis) {
      case 'Penambahan Nutrisi':
        return Icons.opacity_outlined;
      case 'Pergantian Air':
        return Icons.water_outlined;
      case 'Pembersihan Sistem':
        return Icons.cleaning_services_outlined;
      case 'Cek pH & TDS':
        return Icons.science_outlined;
      case 'Pemangkasan':
        return Icons.content_cut_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Jadwal Perawatan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.monitor_heart_outlined),
            tooltip: 'Monitoring',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MonitoringScreen(),
              ),
            ),
          ),
        ],
      ),
      body: _perawatanList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada jadwal perawatan.\nTekan + untuk menambah.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _perawatanList.length,
              itemBuilder: (context, index) {
                final perawatan = _perawatanList[index];
                final selesai = perawatan.status == 'Selesai';
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          selesai ? AppColors.success : AppColors.primary,
                      child: Icon(
                        _jenisIcon(perawatan.jenisPerawatan),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      perawatan.jenisPerawatan,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        decoration: selesai ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${perawatan.namaTanaman} • '
                      '${formatTanggal(perawatan.tanggal)}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            selesai
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: selesai
                                ? AppColors.success
                                : AppColors.textLight,
                          ),
                          tooltip: selesai
                              ? 'Tandai belum selesai'
                              : 'Tandai selesai',
                          onPressed: () => setState(
                            () => PerawatanService.toggleStatus(perawatan.id),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          tooltip: 'Hapus',
                          onPressed: () => _confirmDelete(perawatan),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openInsert,
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
