import 'package:flutter/material.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://eifwtejrfswcizdtihwl.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpZnd0ZWpyZnN3Y2l6ZHRpaHdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMjg1ODAsImV4cCI6MjA2NDYwNDU4MH0.A2bqQU3AgI6SrFvAVDPn_0GTRedE0LWdqRJyEEgHfr4';
}

class AppColors {
  // This class is not meant to be instantiated.
  // We use a private constructor to prevent it.
  AppColors._();

  // --- PRIMARY COLORS ---
  /// The main brand color for the app.
  /// Used for buttons, active icons, and important elements.
  static const Color primary = Color.fromARGB(255, 120, 9, 172); // Classic Blue
  static const Color primaryLight = Color.fromARGB(255, 157, 15, 223);
  static const Color background = Colors.white; // Very light grey
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFDEE2E6);
  static const Color textPrimary = Color(0xFF212529); // Almost black
  static const Color textSecondary = Color(0xFF6C757D); // Grey
  static const Color textOnPrimary = Colors.white;
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
}
