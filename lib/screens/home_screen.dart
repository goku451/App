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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with centered logo and notification bell
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Empty container for spacing
                    const SizedBox(width: 24),
                    // Centered logo only
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
              const SizedBox(height: 12),
              Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF41277A),
                ),
              ),
              _isLoadingUser
                  ? Row(
                children: [
                  Container(
                    width: 180,
                    height: 28,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Search box with rounded corners like mockup
              Container(
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
                  decoration: InputDecoration(
                    hintText: "Buscar en SmartSys",
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
              const SizedBox(height: 24),
              // Institutions
              Text("Institución actual",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              _buildInstitutionBannerCard(
                title: "Cloud Sweet",
                description: "Un rincón mágico donde los sueños se hornean, la dulzura no es la meta",
                bannerImagePath: 'assets/images/banners/cloud_banner.jpg',
                avatarImagePath: 'assets/images/avatars/dulceN.png',
                showOptions: true,
              ),
              const SizedBox(height: 12),
              _buildTaskCard(
                tasks: [
                  "Manejo de los registradores y puntos de venta.",
                  "Limpieza y desinfección de áreas de trabajo y exhibición",
                  "Reposición de inventario",
                ],
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              _buildInstitutionBannerCard(
                title: "Totopia",
                description: "Seguimiento de ventas y gestión de donaciones ortográficas.",
                bannerImagePath: 'assets/images/banners/totopia_banner.jpg',
                avatarImagePath: 'assets/images/avatars/totopia.jpg',
                showOptions: true,
              ),
              const SizedBox(height: 12),
              _buildTaskCard(
                tasks: [
                  "Control de productos.",
                  "Atención al cliente.",
                  "Organización del almacén."
                ],
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 24),
              // Tus grupos
              Text("Tus grupos",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              _buildInstitutionBannerCard(
                title: "Aprendizaje de idiomas",
                description: "Mejora tu escritura y aprende nuevos idiomas con ejercicios interactivos.",
                bannerImagePath: 'assets/images/banners/aprendizaje_banner.jpg',
                avatarImagePath: 'assets/images/avatars/idiomas.jpg',
                showOptions: true,
              ),
              const SizedBox(height: 12),
              _buildTaskCard(
                tasks: [
                  "Práctica de escritura.",
                  "Traducción de textos.",
                  "Conversaciones guiadas."
                ],
                backgroundColor: Colors.white,
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

  // Widget para el banner con imagen de fondo y overlay oscuro
  Widget _buildInstitutionBannerCard({
    required String title,
    required String description,
    required String bannerImagePath,
    required String avatarImagePath,
    bool showOptions = false,
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
            if (showOptions)
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

  // Widget separado para las tareas/bullets
  Widget _buildTaskCard({
    required List<String> tasks,
    required Color backgroundColor,
    Color textColor = Colors.black87,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tasks
              .map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ))
              .toList(),
        ),
      ),
    );
  }
}