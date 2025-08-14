// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Welcome Screen - First screen shown to users
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

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
      // Verificar si ya hay una sesión activa
      final isLoggedIn = await ApiService.isLoggedIn();

      if (isLoggedIn && mounted) {
        // Si hay sesión, ir directamente a Home
        print('✅ Sesión activa encontrada, navegando a Home...');
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      // Si no hay sesión, mostrar Welcome
      print('ℹ️ No hay sesión activa, mostrando Welcome...');
      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      print('❌ Error verificando sesión: $e');
      // En caso de error, mostrar Welcome
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mientras verifica la sesión, mostrar splash simple
    if (_isLoading) {
      return Scaffold(
        body: Container(
          color: Colors.white,
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Nuevo diseño que imita tu mockup de Figma
    return Scaffold(
      body: Column(
        children: [
          // Imagen superior que ocupa más espacio y tiene esquinas cortadas
          Expanded(
            flex: 5, // Más espacio para la imagen
            child: ClipPath(
              clipper: CustomImageClipper(), // Clip personalizado para esquinas cortadas
              child: Container(
                width: double.infinity, // Ocupa todo el ancho
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Logo en la esquina superior
                    Positioned(
                      top: 50, // Más abajo para evitar el notch
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

          // Sección inferior con contenido
          Expanded(
            flex: 4, // Menos espacio para el contenido
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome text
                  const Text(
                    'Bienvenido a\nSmartSys',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a1a),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description text
                  const Text(
                    'SmartSys es tu app de confia para unirte a nuestra de comunidad de plataformas descubre todas las increibles plataformas que tenemos para ti!.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),

                  const Spacer(), // Empuja el botón hacia abajo

                  // Start button
                  Container(
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
                      child: const Text(
                        'Iniciar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Help icon at bottom
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                        Icons.help_outline,
                        color: Color(0xFF999999),
                        size: 24
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

// Clipper personalizado para crear el efecto de esquinas cortadas
class CustomImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double cornerRadius = 24.0; // Radio de las esquinas cortadas

    // Comenzar desde la esquina superior izquierda
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cornerRadius);

    // Esquina inferior derecha cortada
    path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - cornerRadius,
        size.height
    );

    // Línea inferior
    path.lineTo(cornerRadius, size.height);

    // Esquina inferior izquierda cortada
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Cerrar el path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}