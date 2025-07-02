import 'package:booksy/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:booksy/admin/screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'config/config.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  await initializeDateFormatting('id_ID', null); // <-- Tambahkan ini juga

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Bisa tambahkan logika lain kalau perlu
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booksy',
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home:
          _initialized
              ? const DashboardScreen()
              : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
