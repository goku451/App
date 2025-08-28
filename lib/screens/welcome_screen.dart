import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/generated/l10n.dart';

// Welcome Screen - First screen shown to users
class WelcomeScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  final VoidCallback onThemeToggle;

  const WelcomeScreen({
    super.key,
    required this.onLocaleChange,
    required this.onThemeToggle,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final isLoggedIn = await ApiService.isLoggedIn();

      if (isLoggedIn && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF41277A),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'SmartSys',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF41277A),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Verificando sesión...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Imagen superior con esquinas cortadas
          Expanded(
            flex: 5,
            child: ClipPath(
              clipper: CustomImageClipper(),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Botón de idioma 🌐
                    Positioned(
                      top: 50,
                      right: 70,
                      child: IconButton(
                        icon: const Icon(Icons.language, color: Colors.white),
                        onPressed: () {
                          final newLocale =
                          Localizations.localeOf(context).languageCode == 'es'
                              ? const Locale('en')
                              : const Locale('es');
                          widget.onLocaleChange(newLocale);
                        },
                      ),
                    ),
                    // Botón de tema DARK/LIGHT
                    Positioned(
                      top: 50,
                      right: 20,
                      child: IconButton(
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.wb_sunny // 
                              : Icons.nightlight_round, // 
                          color: Colors.white,
                        ),
                        onPressed: widget.onThemeToggle,
                      ),
                    ),
                    // Logo superior izquierdo
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Row(
                        children: [
                          Image.asset('assets/logo.png', height: 32),
                          const SizedBox(width: 8),
                          const Text(
                            'SmartSys',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenido inferior
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  Text(
                    S.of(context).welcome,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description text
                  Text(
                    S.of(context).description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),
                  // Start button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF41277A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        S.of(context).Star,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Help icon
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper personalizado para efecto esquinas cortadas
class CustomImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double cornerRadius = 24.0;

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(size.width, size.height,
        size.width - cornerRadius, size.height);
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
