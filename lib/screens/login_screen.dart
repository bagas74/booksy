// import 'package:flutter/material.dart';
// import '../config/config.dart';
// import '../screens/home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Logika untuk menangani proses login
//   void _handleLogin() {
//     // Sembunyikan keyboard
//     FocusScope.of(context).unfocus();

//     // Validasi input
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       // Simulasi proses login
//       // Di sini Anda akan memanggil service otentikasi Anda nantinya
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() => _isLoading = false);
//           // Navigasi ke HomeScreen dan hapus halaman login dari tumpukan
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const HomeScreen()),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 50),
//                   // Header dengan ilustrasi
//                   Center(
//                     // Anda bisa mengganti SvgPicture dengan Image.asset
//                     child: Image.asset('assets/images/logobooksy.png'),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     'Selamat Datang Kembali!',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Masuk untuk melanjutkan petualangan membacamu.',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   const SizedBox(height: 40),

//                   // Form Email
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: _buildInputDecoration(
//                       hint: 'Email',
//                       icon: Icons.email_outlined,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Email tidak boleh kosong';
//                       }
//                       if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                         return 'Masukkan format email yang valid';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Form Password
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: _buildInputDecoration(
//                       hint: 'Kata Sandi',
//                       icon: Icons.lock_outline,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: AppColors.textSecondary,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Kata sandi tidak boleh kosong';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 24),

//                   // Tombol Masuk Utama
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: AppColors.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child:
//                           _isLoading
//                               ? const SizedBox(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 3,
//                                 ),
//                               )
//                               : const Text(
//                                 'Masuk',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: AppColors.textOnPrimary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Link "Daftar Sekarang"
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Belum punya akun? ",
//                         style: TextStyle(color: AppColors.textSecondary),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           // TODO: Navigasi ke halaman pendaftaran
//                           print('Navigasi ke halaman daftar');
//                         },
//                         child: const Text(
//                           'Daftar Sekarang',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method untuk styling input field agar konsisten
//   InputDecoration _buildInputDecoration({
//     required String hint,
//     required IconData icon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: AppColors.textSecondary),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.primary, width: 2),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../config/config.dart';
import '../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- PERUBAHAN DI SINI ---
  // Logika untuk menangani proses login disederhanakan
  void _handleLogin() {
    // Langsung navigasi ke HomeScreen, validasi dan loading dinonaktifkan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
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
                  // Header dengan ilustrasi
                  Center(
                    // Anda bisa mengganti Image.asset dengan SvgPicture jika perlu
                    child: Image.asset(
                      'assets/images/logobooksy.png',
                      height: 120,
                    ),
                  ),
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

                  // Form Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    // Validasi bisa diaktifkan lagi nanti
                    // validator: (value) { ... },
                  ),

                  const SizedBox(height: 16),

                  // Form Password
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
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    // Validasi bisa diaktifkan lagi nanti
                    // validator: (value) { ... },
                  ),

                  const SizedBox(height: 24),

                  // Tombol Masuk Utama
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _handleLogin, // Langsung panggil fungsi navigasi
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Link "Daftar Sekarang"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun? ",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigasi ke halaman pendaftaran
                          print('Navigasi ke halaman daftar');
                        },
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method untuk styling input field
  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
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
