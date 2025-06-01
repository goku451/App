import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 4; // Profile tab selected

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
      // Already on settings screen
      break;
  }
}

  // Función para cerrar sesión
  Future<void> _logout() async {
    try {
      // Limpiar token guardado
      await ApiService.logout();
      
      // ✅ INMEDIATAMENTE navegar a Welcome y limpiar todo el stack
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/', // Ir a ruta raíz (Welcome)
          (route) => false, // Limpiar todo el stack de navegación
        );
      }
      
      // Mostrar mensaje después de navegar
      Fluttertoast.showToast(
        msg: 'Sesión cerrada correctamente',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      
    } catch (e) {
      // Mostrar error si algo sale mal
      Fluttertoast.showToast(
        msg: 'Error al cerrar sesión',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Mostrar diálogo de confirmación para cerrar sesión
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                _logout(); // Ejecutar logout
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF41277A),
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
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

              // Title
              Text(
                "Configuración y privacidad",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Configuración y configuraciones",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: ListView(
                  children: [
                    // Account section
                    _buildSectionTitle("Cuenta"),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.person,
                        title: "Mi Cuenta",
                        onTap: () => Navigator.pushNamed(context, '/account'),
                      ),
                      _buildSettingsItem(
                        icon: Icons.lock,
                        title: "Privacidad",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.security,
                        title: "Seguridad y Privacidad",
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Main content section
                    _buildSectionTitle("Contenido principal"),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.report_problem,
                        title: "Reportar un problema",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.help,
                        title: "Ayuda",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.description,
                        title: "Términos y políticas",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.info,
                        title: "Acerca de",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.policy,
                        title: "Términos y políticas",
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Help and information section
                    _buildSectionTitle("Ayuda e información"),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.support,
                        title: "Centro de ayuda",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.help_outline,
                        title: "Ayuda",
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.bug_report,
                        title: "Reportar un problema",
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // ✅ BOTÓN DE CERRAR SESIÓN - ACTUALIZADO
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
                      child: ListTile(
                        leading: Icon(Icons.logout, color: const Color(0xFF41277A)),
                        title: Text(
                          "Cerrar sesión",
                          style: TextStyle(
                            color: const Color(0xFF41277A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right, color: const Color(0xFF41277A)),
                        onTap: _showLogoutDialog, // ← Función de logout
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom navigation bar - CORREGIDO
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),        // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),  // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined), // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),         // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),       // Consistente
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF41277A), // Color SmartSys
        unselectedItemColor: Colors.grey[400],      // Consistente
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
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
    );
  }
}