import 'screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://eifwtejrfswcizdtihwl.supabase.co', // Ganti dengan URL proyekmu
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVpZnd0ZWpyZnN3Y2l6ZHRpaHdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMjg1ODAsImV4cCI6MjA2NDYwNDU4MH0.A2bqQU3AgI6SrFvAVDPn_0GTRedE0LWdqRJyEEgHfr4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booksy',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const HomeScreen(),
    );
  }
}
