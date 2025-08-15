import 'package:flutter/material.dart';

class InstitutionsScreen extends StatefulWidget {
  const InstitutionsScreen({super.key});

  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  int _selectedIndex = 2; // Institutions tab selected
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        Navigator.pushReplacementNamed(context, '/chats');
        break;
      case 2:
      // Already on institutions screen
        break;
      case 3:
        Navigator.pushNamed(context, '/calendar');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  void _showInstitutionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Reportar institución'),
                onTap: () {
                  Navigator.pop(context);
                  // Agregar lógica para reportar institución
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Información'),
                onTap: () {
                  Navigator.pop(context);
                  // Agregar lógica para mostrar información
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with centered logo and notification bell
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Empty container for spacing
                  const SizedBox(width: 24),
                  // Centered logo only - optimal size
                  Image.asset(
                    'assets/logo.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.star_outline,
                        size: 130,
                        color: Color(0xFF41277A),
                      );
                    },
                  ),
                  // Notification bell with red dot
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
            ),

            // Search bar with rounded corners like mockup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Buscar plataforma",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.search, color: Colors.grey[400], size: 20),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Grupos Recientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Institutions list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildInstitutionBannerCard(
                    title: "Matemáticas Profe Alex",
                    description: "En este canal encontrarás cursos de matemáticas y física explicados de manera sencilla",
                    bannerImagePath: 'assets/images/banners/alex_banner.jpg',
                    avatarImagePath: 'assets/images/avatars/alex.jpg',
                  ),
                  const SizedBox(height: 16),
                  _buildInstitutionBannerCard(
                    title: "Pollo Pinulito",
                    description: "!El pollo más sabroso de El Salvador!",
                    bannerImagePath: 'assets/images/banners/pinulito_banner.jpg',
                    avatarImagePath: 'assets/images/avatars/pinulito.jpg',
                  ),
                  const SizedBox(height: 16),
                  _buildInstitutionBannerCard(
                    title: "A Cierta Ciencia",
                    description: "Conviértete en un genio de las ciencias",
                    bannerImagePath: 'assets/images/banners/acc_banner.jpg',
                    avatarImagePath: 'assets/images/avatars/acc.jpg',
                  ),
                  const SizedBox(height: 16),
                  _buildInstitutionBannerCard(
                    title: "Fmln",
                    description: "Frente Farabundo Martí para la Liberación Nacional",
                    bannerImagePath: 'assets/images/banners/fmln_banner.png',
                    avatarImagePath: 'assets/images/avatars/fmln.png',
                  ),
                  const SizedBox(height: 16),
                  _buildInstitutionBannerCard(
                    title: "Elim",
                    description: "Misión Cristiana",
                    bannerImagePath: 'assets/images/banners/elim_banner.png',
                    avatarImagePath: 'assets/images/avatars/elim.png',
                  ),
                  const SizedBox(height: 16),
                  _buildInstitutionBannerCard(
                    title: "Alianza FC",
                    description: "Información sobre partidos, plantillas y más",
                    bannerImagePath: 'assets/images/banners/alianza_banner.jpg',
                    avatarImagePath: 'assets/images/avatars/alianza.png',
                  ),
                  const SizedBox(height: 80), // Extra space for floating button
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

  // Widget para el banner con imagen de fondo y overlay oscuro
  Widget _buildInstitutionBannerCard({
    required String title,
    required String description,
    required String bannerImagePath,
    required String avatarImagePath,
  }) {
    return Container(
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
            // Imagen de fondo
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                bannerImagePath,
                fit: BoxFit.cover,
                // Fallback en caso de que la imagen no se encuentre
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.pink.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white.withOpacity(0.5),
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            // Overlay oscuro semitransparente
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Contenido del banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar del lado derecho
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    backgroundImage: AssetImage(avatarImagePath),
                  ),
                ],
              ),
            ),
            // Botón de opciones (3 puntos) más pequeño y mejor posicionado
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _showInstitutionOptions(context),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}