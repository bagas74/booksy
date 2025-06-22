// lib/services/onboarding_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/onboarding_item.dart';

class OnboardingService {
  final _supabase = Supabase.instance.client;

  Future<List<OnboardingItem>> fetchOnboardingItems() async {
    try {
      final response = await _supabase
          .from('onboarding_pages')
          .select()
          .order('order_number', ascending: true);

      return response
          .map<OnboardingItem>((data) => OnboardingItem.fromMap(data))
          .toList();
    } catch (e) {
      debugPrint('Error fetching onboarding items: $e');
      throw 'Gagal memuat data onboarding.';
    }
  }
}
