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
  String userName = "Usuario"; // Valor por defecto
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario actual
  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      
      if (user != null && mounted) {
        setState(() {
          userName = user.nombreCompleto;
          _isLoadingUser = false;
        });
        print('✅ Usuario cargado: $userName');
      } else {
        // Si no hay datos del usuario, usar nombre por defecto
        setState(() {
          userName = "Usuario";
          _isLoadingUser = false;
        });
        print('⚠️ No se encontraron datos del usuario');
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario: $e');
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
  
  // Navigate based on selected index
  switch (index) {
    case 0:
      // Already on home screen
      break;
    case 1:
      Navigator.pushNamed(context, '/chats'); // Navega a chats
      break;
    case 2:
      Navigator.pushNamed(context, '/institutions'); // ✅ NUEVO - Navega a instituciones
      break;
    case 3:
      Navigator.pushNamed(context, '/calendar'); // Navega a calendario
      break;
    case 4:
      Navigator.pushNamed(context, '/settings'); // Navega a configuración
      break;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with logo and notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo section
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
                  // Notification bell
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

              // Welcome text with dynamic user name
              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
              
              // ✅ NOMBRE DINÁMICO DEL USUARIO
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
                    userName,
                    style: const TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
              const SizedBox(height: 16),

              // Search bar
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
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Institution section
              Text(
                "Institución actual",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 12),

              // Institution card with image background
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Background image
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.pink.shade300,
                              Colors.pink.shade500,
                              Colors.pink.shade700,
                            ],
                          ),
                        ),
                      ),
                      // Pattern overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cloud Sweet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Un rincón mágico donde los sueños se hornean,\nla dulzura no es la meta",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Manejo de los registradores y puntos de venta.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Image.asset(
                                'assets/images/avatars/dulceN.png', 
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.cake, size: 25, color: Colors.pink);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Groups section
              Text(
                "Tus grupos",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 12),

              // Group cards - scrollable with improved design
              Expanded(
                child: ListView(
                  children: [
                    // First group card - Totopia
                    _buildModernGroupCard(
                      title: "Totopia",
                      description: "Seguimiento de ventas y gestión de\ndonaciones ortográficas.",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade800,
                          Colors.grey.shade900,
                          Colors.black,
                        ],
                      ),
                      icon: Icons.computer,
                      iconColor: Colors.white,
                    ),
                    const SizedBox(height: 16),

                    // Second group card - Language Learning
                    _buildModernGroupCard(
                      title: "Aprendizaje de idiomas",
                      description: "Mejora tu escritura y aprende nuevos\nidiomas con ejercicios interactivos.",
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                          Colors.blue.shade800,
                        ],
                      ),
                      icon: Icons.language,
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new group or action
        },
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
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

  // Helper method to build modern group cards with gradients
  Widget _buildModernGroupCard({
    required String title,
    required String description,
    required LinearGradient gradient,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(gradient: gradient),
            ),
            // Pattern overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 22,
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}