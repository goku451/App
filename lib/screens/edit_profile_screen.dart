import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _selectedIndex = 4; // Profile tab selected
  final String userName = "Elmer Rivas";
  final String userEmail = "elmer@gmail.com";
  final String username = "ElmerR";

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
      // Already on profile screen
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
                "Editar Perfil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Profile form
              Expanded(
                child: Container(
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
                  child: Column(
                    children: [
                      // Profile picture section
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: AssetImage('assets/profile_image.jpg'),
                              child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                // Handle change picture
                                _showImagePicker();
                              },
                              child: Text(
                                "Cambiar Foto",
                                style: TextStyle(
                                  color: const Color(0xFF41277A), // Color SmartSys
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),

                      // Acerca de ti section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Acerca de ti",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form fields
                      Expanded(
                        child: ListView(
                          children: [
                            _buildEditableProfileField("Nombre", userName),
                            const SizedBox(height: 16),
                            _buildEditableProfileField("Nombre de usuario", username),
                            const SizedBox(height: 16),
                            _buildEditableProfileField("Correo electrónico", userEmail),
                            const SizedBox(height: 16),
                            _buildEditableProfileField("Descripción", "Sin biografía aún"),
                            const SizedBox(height: 16),
                            _buildEditableProfileField("Recomendaciones", "Música, Deportes"),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildEditableProfileField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _editField(label, value);
            },
            child: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cambiar foto de perfil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: const Color(0xFF41277A)), // Color SmartSys
                title: Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle camera
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: const Color(0xFF41277A)), // Color SmartSys
                title: Text("Elegir de galería"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editField(String label, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar $label"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Ingresa tu $label",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: label == "Descripción" ? 3 : 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle save
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$label actualizado"),
                    backgroundColor: const Color(0xFF41277A), // Color SmartSys
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF41277A), // Color SmartSys
                foregroundColor: Colors.white,
              ),
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}