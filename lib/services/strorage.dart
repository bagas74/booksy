import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  String getPublicImageUrl(String imagePath) {
    return _client.storage.from('images').getPublicUrl(imagePath);
  }
}
