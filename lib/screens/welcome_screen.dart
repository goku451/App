import 'package:flutter/material.dart';

// Welcome Screen - First screen shown to users
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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