import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}


class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 4; // Profile tab selected
  final String userName = "Elmer Rivas";

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
                      backgroundImage: AssetImage('assets/profile_image.jpg'),
                      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
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
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF41277A), // Color SmartSys
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Hazte Premium",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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