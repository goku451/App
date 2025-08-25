import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/generated/l10n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required void Function(Locale locale) onLocaleChange,
    required void Function() onThemeToggle,
  });

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
        Navigator.pushNamed(
          context,
          '/institutions',
        ); // ✅ NUEVO - Navega a instituciones
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
        msg: S.of(context).Message_Correct_Out_Sesion,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
              : Colors.white, // blanco en modo claro
          title: Text(
            S.of(context).Close_Session,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: Text(
            S.of(context).Message_Close_Session,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: Text(
                S.of(context).Cancel,
                style: TextStyle(
                  color: Colors.grey[isDarkMode ? 400 : 600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                _logout(); // Ejecutar logout
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF41277A),
              ),
              child: Text(S.of(context).Close_Session),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: Theme.of(context).colorScheme.onBackground,
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
                S.of(context).Settings,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              Text(
                S.of(context).Setting_Privacy,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[isDarkMode ? 400 : 600],
                ),
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: ListView(
                  children: [
                    // Account section
                    _buildSectionTitle(S.of(context).Account),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.person,
                        title: S.of(context).My_Account,
                        onTap: () => Navigator.pushNamed(context, '/account'),
                      ),
                      _buildSettingsItem(
                        icon: Icons.lock,
                        title: S.of(context).Setting_Privacy,
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Main content section
                    _buildSectionTitle(S.of(context).Main_Content),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.description,
                        title: S.of(context).Terms_and_Policies,
                        onTap: () {},
                      ),
                      _buildSettingsItem(
                        icon: Icons.info,
                        title: S.of(context).About,
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Help and information section
                    _buildSectionTitle(S.of(context).Help_Info),
                    const SizedBox(height: 12),
                    _buildSettingsCard([
                      _buildSettingsItem(
                        icon: Icons.help_outline,
                        title: S.of(context).Help,
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // BOTÓN DE CERRAR SESIÓN
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
                            : Colors.white, // blanco en modo claro
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.3) // sombra más fuerte en modo oscuro
                                : Colors.black.withOpacity(0.05), // sombra más suave en modo claro
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: const Color(0xFF41277A),
                        ),
                        title: Text(
                          S.of(context).Close_Session,
                          style: TextStyle(
                            color: const Color(0xFF41277A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: const Color(0xFF41277A),
                        ),
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

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
            : Colors.white, // blanco en modo claro
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined), // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline), // Consistente
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Consistente
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF41277A), // Color SmartSys
        unselectedItemColor: Colors.grey[400], // Consistente
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[isDarkMode ? 400 : 700],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
            : Colors.white, // blanco en modo claro
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3) // sombra más fuerte en modo oscuro
                : Colors.grey.withOpacity(0.1), // sombra más suave en modo claro
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[isDarkMode ? 400 : 700],
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}