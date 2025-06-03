import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Masuk Ke Booksy',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk lanjutkan membaca buku favoritmu',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 32),

            const Text('Email'),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Email',
              ),
            ),

            const SizedBox(height: 16),

            const Text('Kata sandi'),
            const SizedBox(height: 4),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text('Ingat Saya'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    print('Lupa sandi ditekan');
                  },
                  child: const Text('Lupa Sandi?'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Masuk'),
              ),
            ),

            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  print('Klik daftar Sekarang');
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Belum punya akun?",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Daftar Sekarang",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
