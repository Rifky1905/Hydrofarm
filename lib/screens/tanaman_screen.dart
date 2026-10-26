import 'package:flutter/material.dart';

import '../models/tanaman_model.dart';
import '../services/tanaman_service.dart';
import '../theme/app_colors.dart';
import 'monitoring_screen.dart';
import 'tanaman_detail.dart';
import 'tanaman_insert.dart';
import 'tanaman_update.dart';

class TanamanScreen extends StatefulWidget {
  const TanamanScreen({super.key});

  @override
  State<TanamanScreen> createState() => _TanamanScreenState();
}

class _TanamanScreenState extends State<TanamanScreen> {
  List<Tanaman> _tanamanList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await TanamanService.getAll();
      setState(() => _tanamanList = data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data tanaman: $e')),
        );
      }
    }
  }

  Future<void> _openDetail(Tanaman tanaman) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TanamanDetail(tanaman: tanaman),
      ),
    );
    _loadData(); // refresh jika data dihapus/diubah dari halaman detail
  }

  Future<void> _openInsert() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TanamanInsert()),
    );
    _loadData(); // refresh setelah menambah data
  }

  Future<void> _openEdit(Tanaman tanaman) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TanamanUpdate(tanaman: tanaman),
      ),
    );
    _loadData(); // refresh setelah mengubah data
  }

  void _openMonitoring() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MonitoringScreen()),
    );
  }

  Future<void> _confirmDelete(Tanaman tanaman) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: Text('Hapus data "${tanaman.nama}"?'),
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
      try {
        await TanamanService.delete(tanaman.id);
        _loadData();
      } catch (e) {
        debugPrint('Gagal menghapus tanaman: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus tanaman: $e')),
          );
        }
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Siap Panen':
        return AppColors.success;
      case 'Dipanen':
        return AppColors.textLight;
      case 'Berbunga':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Data Tanaman'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.monitor_heart_outlined),
            tooltip: 'Monitoring',
            onPressed: _openMonitoring,
          ),
        ],
      ),
      body: _tanamanList.isEmpty
          ? const Center(
              child: Text('Belum ada data tanaman.\nTekan + untuk menambah.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tanamanList.length,
              itemBuilder: (context, index) {
                final tanaman = _tanamanList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.eco, color: Colors.white),
                    ),
                    title: Text(
                      tanaman.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${tanaman.jenis} • '
                      'Tanam: ${formatTanggal(tanaman.tanggalTanam)}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            tanaman.status,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: _statusColor(tanaman.status),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.info,
                          ),
                          tooltip: 'Edit',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _openEdit(tanaman),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          tooltip: 'Hapus',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _confirmDelete(tanaman),
                        ),
                      ],
                    ),
                    onTap: () => _openDetail(tanaman),
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
