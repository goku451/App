import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

// Home Screen - Dashboard after login
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? userName;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          userName = user.nombreCompleto;
          _isLoadingUser = false;
        });
      } else {
        setState(() {
          userName = "Usuario";
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Usuario";
        _isLoadingUser = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      case 2:
        Navigator.pushNamed(context, '/institutions');
        break;
      case 3:
        Navigator.pushNamed(context, '/calendar');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.star_outline,
                            size: 24,
                            color: Color(0xFF41277A),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SmartSys',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: Colors.black54,
                      ),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
              _isLoadingUser
                  ? Row(
                children: [
                  Container(
                    width: 150,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              )
                  : Text(
                userName ?? "Usuario",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Search box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar en SmartSys",
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Institutions
              Text("Institución actual",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              _buildInstitutionCard(
                title: "Cloud Sweet",
                description:
                "Un rincón mágico donde los sueños se hornean, la dulzura no es la meta",
                tasks: [
                  "Manejo de los registradores y puntos de venta.",
                  "Limpieza y desinfección de áreas de trabajo y exhibición",
                  "Reposición de inventario",
                ],
                backgroundColor: Colors.pink.shade100,
                imagePath: 'assets/images/avatars/dulceN.png',
              ),
              const SizedBox(height: 16),
              _buildInstitutionCard(
                title: "Totopia",
                description:
                "Seguimiento de ventas y gestión de donaciones ortográficas.",
                tasks: [
                  "Control de productos.",
                  "Atención al cliente.",
                  "Organización del almacén."
                ],
                backgroundColor: Colors.lightBlue.shade100,
                imagePath: 'assets/images/avatars/totopia.jpg',
              ),
              const SizedBox(height: 24),
              // Tus grupos
              Text("Tus grupos",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              _buildInstitutionCard(
                title: "Aprendizaje de idiomas",
                description:
                "Mejora tu escritura y aprende nuevos idiomas con ejercicios interactivos.",
                tasks: [
                  "Práctica de escritura.",
                  "Traducción de textos.",
                  "Conversaciones guiadas."
                ],
                backgroundColor: Colors.lightGreen.shade100,
                imagePath: 'assets/images/avatars/idiomas.jpg',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF41277A),
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildInstitutionCard({
    required String title,
    required String description,
    required List<String> tasks,
    required Color backgroundColor,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tasks
                        .map((task) => Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            task,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              backgroundImage: AssetImage(imagePath),
            ),
          ],
        ),
      ),
    );
  }
}
