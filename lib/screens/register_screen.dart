import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required void Function(Locale locale) onLocaleChange,
    required void Function() onThemeToggle,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.register(
        nombre: _nameController.text.trim(),
        apellido: _lastNameController.text.trim(),
        correoElectronico: _emailController.text.trim(),
        contrasena: _passwordController.text,
      );

      if (response.success && response.data != null) {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error inesperado: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Usuario canceló el login de Google");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final nombre = user.displayName?.split(' ').first ?? '';
        final apellido = user.displayName?.split(' ').skip(1).join(' ') ?? '';
        final correo = user.email ?? '';

        final response = await ApiService.saveGoogleUser(
          nombre: nombre,
          apellido: apellido,
          email: correo,
        );

        if (response.success) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Error guardando el usuario: ${response.message}",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error con Google: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error Google Sign-In: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/logo_dark.png'
                    : 'assets/logo.png',
                height: 40,
              ),
              const SizedBox(height: 32),

              Text(
                S.of(context).Create_Acoount,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                S.of(context).Register,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF41277A),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                S.of(context).Register_text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          enabled: !_isLoading,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: S.of(context).Name,
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF41277A),
                              ),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return S.of(context).Error_Name;
                            if (value.trim().length < 2)
                              return S.of(context).Error_Name2;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _lastNameController,
                          enabled: !_isLoading,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: S.of(context).Last_Name,
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF41277A),
                              ),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return S.of(context).Error_Last_Name;
                            if (value.trim().length < 2)
                              return S.of(context).Error_Last_Name2;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: S.of(context).Email,
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF41277A),
                              ),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                              return S.of(context).Error_Email;
                            final emailRegex = RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            );
                            if (!emailRegex.hasMatch(value.trim()))
                              return S.of(context).Error_Email2;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          decoration: InputDecoration(
                            hintText: S.of(context).Password,
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Color(0xFFDDDDE3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF41277A),
                              ),
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF7B7B8A),
                              ),
                              onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return S.of(context).Error_Password;
                            if (value.length < 8)
                              return S.of(context).Error_Password2;
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF41277A),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                shadows: [],
                              ),
                            ),
                            child:
                            _isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(S.of(context).Create_Account_Buttom),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _signInWithGoogle, // <- Cambiado aquí
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(
                                color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                                width: 1,
                              ),
                              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/avatars/google.webp',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text('G', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Registrarse con Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            S.of(context).Have_Account,
                            style: const TextStyle(color: Color(0xFF7B7B8A)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.help_outline,
                  color: Color(0xFFB0B0B8),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}