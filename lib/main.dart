import 'package:booksy/screens/home_screen.dart';
import 'package:booksy/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/config.dart';
import 'screens/signup_screen.dart';
import 'admin/screens/admin_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home:
          _initialized
              ? const SplashScreen()
              : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
