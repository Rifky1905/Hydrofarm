/// Kredensial project Supabase.
///
/// 1. Buat project di https://supabase.com
/// 2. Project Settings > API > salin "Project URL" dan "anon public key"
/// 3. Tempel di bawah ini.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://pqsrksenrzucszuvcygei.supabase.co';

  /// "anon public key" (project lama) atau "publishable key" (project baru).
  static const String publishableKey =
      'sb_publishable_6nQ43vYdLI0FNDEtAfdohw_ZbG2AR_X';

  /// true jika kredensial sudah diisi (bukan placeholder).
  static bool get isConfigured =>
      !url.contains('YOUR_PROJECT') &&
      url.startsWith('https://') &&
      !publishableKey.contains('YOUR_') &&
      publishableKey.length > 20;
}
