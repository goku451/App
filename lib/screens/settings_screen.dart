import 'package:flutter/material.dart';

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
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_none, size: 28),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 8,
                          child: Text(
                            "4",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
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

                    // Delete account button
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
                        leading: Icon(Icons.delete_forever, color: Colors.red),
                        title: Text(
                          "Desactivar o eliminar cuenta",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Colors.red),
                        onTap: () {
                          // Handle delete account
                        },
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