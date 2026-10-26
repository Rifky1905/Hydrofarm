import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';
import 'services/supabase_config.dart';
import 'services/tanaman_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase hanya jika kredensial sudah diisi.
  // Jika gagal/belum diisi, aplikasi tetap jalan memakai data in-memory.
  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.publishableKey,
      );
      TanamanService.useRemote = true;
    } catch (e) {
      debugPrint('Supabase init gagal, memakai data lokal: $e');
    }
  }

  runApp(const HydroFarmApp());
}

class HydroFarmApp extends StatelessWidget {
  const HydroFarmApp({super.key});

  static const Color primaryColor = Color(0xFF0B6B72);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HydroFarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
