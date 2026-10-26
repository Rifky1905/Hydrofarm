import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_config.dart';
import 'login_screen.dart';
import 'monitoring_screen.dart';
import 'perawatan_screen.dart';
import 'tanaman_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/logo_icon.png'),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF16707E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF16707E)),
            tooltip: 'Logout',
            onPressed: () async {
              if (SupabaseConfig.isConfigured) {
                try {
                  await Supabase.instance.client.auth.signOut();
                } catch (_) {}
              }
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang di HydroFarm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16707E),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kelola tanaman hidroponik dengan lebih mudah.',
              style: TextStyle(color: Color(0xFF7A8B99)),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                _MenuCard(
                  title: 'Tanaman',
                  icon: Icons.eco,
                  iconColor: const Color(0xFF43A047),
                  iconBackground: const Color(0xFFE4F2E5),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TanamanScreen(),
                    ),
                  ),
                ),
                _MenuCard(
                  title: 'Perawatan',
                  icon: Icons.calendar_month_outlined,
                  iconColor: const Color(0xFF16707E),
                  iconBackground: const Color(0xFFE0EFF1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PerawatanScreen(),
                    ),
                  ),
                ),
                _MenuCard(
                  title: 'Monitoring',
                  icon: Icons.monitor_heart_outlined,
                  iconColor: const Color(0xFF1E88E5),
                  iconBackground: const Color(0xFFE3EFFA),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonitoringScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      shadowColor: Colors.black12,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
