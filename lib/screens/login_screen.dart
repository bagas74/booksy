// --- AWAL PERUBAHAN ---
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- Ditambahkan
import 'package:cached_network_image/cached_network_image.dart'; // <-- Ditambahkan
// --- AKHIR PERUBAHAN ---
import '../config/config.dart';
import '../screens/home_screen.dart';
import '../admin/screens/admin_home_screen.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // --- AWAL PERUBAHAN ---
  late Future<String>
  _logoUrlFuture; // <-- Ditambahkan untuk menampung proses fetch

  @override
  void initState() {
    super.initState();
    // Memulai proses pengambilan URL logo saat halaman pertama kali dibuka
    _logoUrlFuture = _getLogoUrl(); // <-- Ditambahkan
  }
  // --- AKHIR PERUBAHAN ---

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- AWAL PERUBAHAN ---
  /// Mengambil URL logo dari tabel 'app_settings' di Supabase.
  Future<String> _getLogoUrl() async {
    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase
              .from('app_settings') // Nama tabel Anda
              .select('setting_value') // Kolom yang berisi URL
              .eq('setting_name', 'app_logo_url') // Kunci untuk logo
              .single();

      // Mengembalikan URL jika ada, atau string kosong jika tidak ditemukan
      return response['setting_value'] as String? ?? '';
    } catch (e) {
      debugPrint('Error fetching logo URL: $e');
      // Kembalikan string kosong jika terjadi error (misal: offline)
      // Ini akan memicu fallback ke logo lokal di FutureBuilder
      return '';
    }
  }
  // --- AKHIR PERUBAHAN ---

  /// Menangani logika login dengan notifikasi sukses dan gagal
  Future<void> _handleLogin() async {
    // ... Logika login Anda tidak berubah ...
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final role = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login berhasil!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (mounted) {
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Login gagal! Pastikan email dan password sudah benar.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  // --- AWAL PERUBAHAN ---
                  Center(
                    child: FutureBuilder<String>(
                      future:
                          _logoUrlFuture, // Menggunakan future yang sudah diinisiasi
                      builder: (context, snapshot) {
                        // 1. State: Sedang mengambil data
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // 2. State: Error atau tidak ada data/URL
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Tampilkan logo lokal dari assets sebagai cadangan (fallback)
                          return Image.asset(
                            'assets/images/logobooksy.png',
                            height: 120,
                          );
                        }

                        // 3. State: Sukses, data URL tersedia
                        final logoUrl = snapshot.data!;
                        return CachedNetworkImage(
                          imageUrl: logoUrl,
                          height: 120,
                          placeholder:
                              (context, url) => const SizedBox(
                                height: 120,
                                width: 120,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Image.asset(
                                'assets/images/logobooksy.png', // Fallback jika URL error
                                height: 120,
                              ),
                        );
                      },
                    ),
                  ),

                  // --- AKHIR PERUBAHAN ---
                  const SizedBox(height: 30),
                  const Text(
                    'Selamat Datang Kembali!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk untuk melanjutkan petualangan membacamu.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ... Sisa kode Anda (TextFormField, Button, dll) tetap sama ...
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    validator:
                        (value) =>
                            (value == null ||
                                    !RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                                ? 'Masukkan email yang valid'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _buildInputDecoration(
                      hint: 'Kata Sandi',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                      ),
                    ),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Kata sandi tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun? ",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            ),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    // ... Fungsi ini tidak berubah ...
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
