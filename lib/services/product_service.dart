import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Product>> fetchProductsByType(String type) async {
    final response = await _client
        .from('products')
        .select()
        .eq('type', type); // 'trending' atau 'new'

    final data = response as List;
    return data.map((item) => Product.fromJson(item)).toList();
  }
}
