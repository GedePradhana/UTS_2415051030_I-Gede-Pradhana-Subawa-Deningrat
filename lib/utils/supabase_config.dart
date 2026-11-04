/// Konfigurasi Supabase dibaca dari --dart-define-from-file=env.json
/// (file env.json tidak di-commit).
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String key = String.fromEnvironment('SUPABASE_KEY');

  static bool get isConfigured => url.isNotEmpty && key.isNotEmpty;
}