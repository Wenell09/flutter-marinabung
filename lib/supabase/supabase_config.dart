import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"]!,
      anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
    );
  }
}
