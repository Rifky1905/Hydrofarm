/// Kredensial project Supabase.
///
/// Diambil dari --dart-define saat build (dipakai oleh CI/Vercel):
///   flutter build web --release \
///     --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=sb_publishable_xxx
///
/// defaultValue dipakai saat run lokal tanpa flag.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lthmpgagswqwoqltavik.supabase.co',
  );

  /// "anon public key" (project lama) atau "publishable key" (project baru).
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_EVmRzm0qipcjHiERxK0lww_EC7Ddf7Z',
  );

  /// true jika kredensial sudah diisi (bukan placeholder).
  static bool get isConfigured =>
      !url.contains('YOUR_PROJECT') &&
      url.startsWith('https://') &&
      !publishableKey.contains('YOUR_') &&
      publishableKey.length > 20;
}
