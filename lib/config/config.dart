import 'package:flutter/material.dart';

// lib/utils/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://eifwtejrfswcizdtihwl.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpZnd0ZWpyZnN3Y2l6ZHRpaHdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMjg1ODAsImV4cCI6MjA2NDYwNDU4MH0.A2bqQU3AgI6SrFvAVDPn_0GTRedE0LWdqRJyEEgHfr4';
}

/// A class that holds all the color constants for the app.
/// This ensures a consistent color palette across the entire application.
class AppColors {
  // This class is not meant to be instantiated.
  // We use a private constructor to prevent it.
  AppColors._();

  // --- PRIMARY COLORS ---
  /// The main brand color for the app.
  /// Used for buttons, active icons, and important elements.
  static const Color primary = Color.fromARGB(255, 120, 9, 172); // Classic Blue

  /// A lighter shade of the primary color.
  static const Color primaryLight = Color.fromARGB(255, 157, 15, 223);

  // --- NEUTRAL COLORS ---
  /// The main background color for most screens.
  static const Color background = Color(0xFFF8F9FA); // Very light grey

  /// The color for surfaces like cards, bottom sheets, and dialogs.
  static const Color surface = Colors.white;

  /// The color for borders, dividers, and disabled elements.
  static const Color border = Color(0xFFDEE2E6);

  // --- TEXT COLORS ---
  /// The primary text color for headings and main content.
  static const Color textPrimary = Color(0xFF212529); // Almost black

  /// The secondary text color for subtitles, captions, and less important text.
  static const Color textSecondary = Color(0xFF6C757D); // Grey

  /// Text color for elements on a primary color background.
  static const Color textOnPrimary = Colors.white;

  // --- SEMANTIC COLORS ---
  /// Color to indicate an error state.
  static const Color error = Color(0xFFDC3545);

  /// Color to indicate a successful operation.
  static const Color success = Color(0xFF28A745);

  /// Color for warning messages.
  static const Color warning = Color(0xFFFFC107);
}
