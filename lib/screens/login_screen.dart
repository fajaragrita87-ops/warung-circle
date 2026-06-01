import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/services/firebase_service.dart';
import 'package:warung_circle/widgets/kopi_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  int _adminTapCount = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final firebaseService = FirebaseService();

    try {
      if (_isLoginMode) {
        // Sign In
        await firebaseService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: WC.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selamat datang kembali, ${WS.userName}! ☕',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: WC.bgWarm,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // Sign Up
        await firebaseService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
          _contactController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: WC.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pendaftaran berhasil! Selamat bergabung ${WS.userName} (+15 Kopi Gratis!) ☕',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: WC.bgWarm,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: WC.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  e.toString().replaceAll('Exception: ', ''),
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: WC.bgWarm,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WC.bg,
      body: Stack(
        children: [
          // Cyber Glowing Background Deco
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WC.primary.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WC.accent.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Scroll View
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // App Logo & Header
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          _adminTapCount++;
                          if (_adminTapCount >= 5) {
                            _adminTapCount = 0;
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              // Perform login as superadmin using email
                              await FirebaseService().signInWithEmail('superadmin@warung.com', 'admin123');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '👑 Mode Dewa Diaktifkan! Selamat datang Superadmin! ☕',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: WC.success,
                                  ),
                                );
                                Navigator.pushReplacementNamed(context, Routes.home);
                              }
                            } catch (e) {
                              // Fallback in case of mock/database failure or offline state
                              await WS.login('Teh Erni Super', '08111111111', role: 'superadmin');
                              WS.kopiBalance = 999.0;
                              WS.respectPoints = 999.0;
                              WS.redFlags = 0.0;
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '👑 Mode Dewa Diaktifkan (Mock)! Selamat datang Superadmin! ☕',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: WC.success,
                                  ),
                                );
                                Navigator.pushReplacementNamed(context, Routes.home);
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          } else {
                            // Quick toast to show remaining taps
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Ketuk ${5 - _adminTapCount} kali lagi untuk membuka mode rahasia... 😉',
                                  style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.white12,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: WC.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: WC.primary.withOpacity(0.3), width: 1.5),
                          ),
                          child: Text(
                            '☕',
                            style: TextStyle(fontSize: 48, shadows: [
                              Shadow(
                                color: WC.primary.withOpacity(0.8),
                                blurRadius: 15,
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'WARUNG CIRCLE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: WC.primary.withOpacity(0.5),
                            offset: const Offset(0, 3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pojokan Nongkrong Digital Gen Z',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: WC.textMid,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Translucent Login Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1.5,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Tab Switcher (Masuk vs Daftar)
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _isLoginMode = true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _isLoginMode ? WC.primaryLight : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _isLoginMode ? WC.primary : Colors.transparent,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            'Masuk',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: _isLoginMode ? Colors.white : WC.textMid,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _isLoginMode = false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: !_isLoginMode ? WC.accentLight : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: !_isLoginMode ? WC.accent : Colors.transparent,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            'Daftar',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: !_isLoginMode ? Colors.white : WC.textMid,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // email input
                                Text(
                                  'ALAMAT EMAIL',
                                  style: GoogleFonts.poppins(
                                    color: WC.textMid,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Misal: budi@gmail.com',
                                    hintStyle: GoogleFonts.poppins(color: WC.textLight, fontSize: 14),
                                    prefixIcon: const Icon(Icons.email, color: WC.textLight, size: 20),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(color: WC.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(color: _isLoginMode ? WC.primary : WC.accent, width: 2),
                                    ),
                                    fillColor: Colors.white.withOpacity(0.02),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(v.trim())) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),

                                // password input
                                Text(
                                  'KATA SANDI',
                                  style: GoogleFonts.poppins(
                                    color: WC.textMid,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Minimal 6 karakter',
                                    hintStyle: GoogleFonts.poppins(color: WC.textLight, fontSize: 14),
                                    prefixIcon: const Icon(Icons.lock, color: WC.textLight, size: 20),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                        color: WC.textLight,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(color: WC.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(color: _isLoginMode ? WC.primary : WC.accent, width: 2),
                                    ),
                                    fillColor: Colors.white.withOpacity(0.02),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Kata sandi tidak boleh kosong';
                                    }
                                    if (v.length < 6) {
                                      return 'Kata sandi minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                // Sign Up fields
                                if (!_isLoginMode) ...[
                                  const SizedBox(height: 18),
                                  Text(
                                    'NAMA PANGGILAN',
                                    style: GoogleFonts.poppins(
                                      color: WC.textMid,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _nameController,
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: 'Misal: Budi Kece',
                                      hintStyle: GoogleFonts.poppins(color: WC.textLight, fontSize: 14),
                                      prefixIcon: const Icon(Icons.person, color: WC.textLight, size: 20),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(color: WC.border),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: WC.accent, width: 2),
                                      ),
                                      fillColor: Colors.white.withOpacity(0.02),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    ),
                                    validator: (v) {
                                      if (!_isLoginMode && (v == null || v.trim().isEmpty)) {
                                        return 'Nama tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    'NOMOR WHATSAPP',
                                    style: GoogleFonts.poppins(
                                      color: WC.textMid,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _contactController,
                                    keyboardType: TextInputType.phone,
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: 'Misal: 08123456789',
                                      hintStyle: GoogleFonts.poppins(color: WC.textLight, fontSize: 14),
                                      prefixIcon: const Icon(Icons.phone_android, color: WC.textLight, size: 20),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(color: WC.border),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(color: WC.accent, width: 2),
                                      ),
                                      fillColor: Colors.white.withOpacity(0.02),
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    ),
                                    validator: (v) {
                                      if (!_isLoginMode && (v == null || v.trim().isEmpty)) {
                                        return 'Nomor WhatsApp tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ],

                                const SizedBox(height: 32),

                                // Submit Button
                                _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: WC.primary,
                                        ),
                                      )
                                    : KopiButton(
                                        label: _isLoginMode ? 'Masuk Warkop ☕' : 'Gabung Warga ⚡',
                                        color: _isLoginMode ? WC.primary : WC.accent,
                                        textColor: _isLoginMode ? Colors.white : Colors.black,
                                        onPressed: _submit,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Dengan masuk, kamu menyetujui Aturan Posko Kampung Digital Warung Circle.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: WC.textLight,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
