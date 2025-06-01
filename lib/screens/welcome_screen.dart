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

    // Tu diseño original - exactamente igual
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Top section with image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage('assets/fondo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Image.asset('assets/logo.png', height: 40),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Welcome text
              const Text(
                'Bienvenido a\nSmartSys',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Description text
              const Text(
                'SmartSys es tu app de confia para unirte a nuestra de comunidad de plataformas descubre todas las increibles plataformas que tenemos para ti!.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF41277A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Iniciar'),
                ),
              ),
              const SizedBox(height: 32),

              // Help icon at bottom
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.help_outline, color: Colors.grey, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}