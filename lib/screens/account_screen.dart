import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 4; // Profile tab selected
  String userName = "Usuario"; // Valor por defecto
  bool _isLoadingUser = true;
  User? currentUser; // Para acceder a más datos del usuario si es necesario

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
          currentUser = user;
          userName = user.nombreCompleto;
          _isLoadingUser = false;
        });
        print('✅ Usuario cargado en Account: $userName');
      } else {
        // Si no hay datos del usuario, usar nombre por defecto
        setState(() {
          userName = "Usuario";
          _isLoadingUser = false;
        });
        print('⚠️ No se encontraron datos del usuario en Account');
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario en Account: $e');
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
      Navigator.pushReplacementNamed(context, '/home');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/chats'); // Navega a chats
      break;
    case 2:
      Navigator.pushNamed(context, '/institutions'); // ✅ NUEVO - Navega a instituciones
      break;
    case 3:
      Navigator.pushNamed(context, '/calendar'); // Navega a calendario
      break;
    case 4:
      // Already on account screen
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
              // Top bar with notifications
                            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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

              // Welcome section with profile picture
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
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: currentUser?.fotoBytes != null
                          ? MemoryImage(currentUser!.fotoBytes!)
                          : const AssetImage('assets/plat.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bienvenido",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          
                          // ✅ NOMBRE DINÁMICO DEL USUARIO
                          _isLoadingUser 
                            ? Row(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 14,
                                    height: 14,
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings options
              Expanded(
                child: ListView(
                  children: [
                    _buildAccountOption(
                      icon: Icons.settings,
                      title: "Configuración y privacidad",
                      onTap: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.edit,
                      title: "Editar perfil",
                      onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.notifications,
                      title: "Notificaciones",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.bookmark,
                      title: "Elementos guardados",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.history,
                      title: "Historial",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.language,
                      title: "Idioma",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildAccountOption(
                      icon: Icons.dark_mode,
                      title: "Modo oscuro",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Floating action button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color(0xFF41277A), // Color SmartSys
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700], size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}