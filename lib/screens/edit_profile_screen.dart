import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _selectedIndex = 4; // Profile tab selected
  
  // Datos dinámicos del usuario
  User? currentUser;
  bool _isLoadingUser = true;
  bool _isSaving = false;
  
  // Valores editables
  String userName = "Usuario";
  String userEmail = "email@example.com";
  String userPhone = "";
  String userBio = "";

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
          userEmail = user.correoElectronico;
          userPhone = user.telefono ?? "";
          userBio = user.biografia ?? "";
          _isLoadingUser = false;
        });
        print('✅ Usuario cargado en EditProfile: $userName');
      } else {
        setState(() {
          _isLoadingUser = false;
        });
        print('⚠️ No se encontraron datos del usuario en EditProfile');
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario en EditProfile: $e');
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  // Actualizar perfil en la base de datos
  Future<void> _updateProfile({
    required String campo,
    required String nuevoValor,
  }) async {
    if (currentUser == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Preparar datos actualizados
      String nombre = currentUser!.nombre;
      String apellido = currentUser!.apellido;
      String? telefono = currentUser!.telefono;
      String? biografia = currentUser!.biografia;

      // Actualizar el campo específico
      switch (campo) {
        case 'Nombre':
          final nombreParts = nuevoValor.split(' ');
          if (nombreParts.length >= 2) {
            nombre = nombreParts.first;
            apellido = nombreParts.sublist(1).join(' ');
          } else {
            nombre = nuevoValor;
          }
          break;
        case 'Teléfono':
          telefono = nuevoValor.isEmpty ? null : nuevoValor;
          break;
        case 'Descripción':
          biografia = nuevoValor.isEmpty ? null : nuevoValor;
          break;
      }

      // Llamar a la API
      final response = await ApiService.updateProfile(
        idUsuario: currentUser!.idUsuario,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        biografia: biografia,
      );

      if (response.success && response.data != null) {
        // Actualizar datos locales
        setState(() {
          currentUser = response.data;
          userName = response.data!.nombreCompleto;
          userPhone = response.data!.telefono ?? "";
          userBio = response.data!.biografia ?? "";
        });

        // Mostrar mensaje de éxito
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        print('✅ Perfil actualizado: ${response.data!.nombreCompleto}');
      } else {
        // Mostrar error
        Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error inesperado: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
                  child: _isLoadingUser 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF41277A),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando datos del perfil...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Profile picture section
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: AssetImage('assets/plat.png'),
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
                                _buildNonEditableProfileField("Correo electrónico", userEmail),
                                const SizedBox(height: 16),
                                _buildEditableProfileField("Teléfono", userPhone.isEmpty ? "Sin teléfono" : userPhone),
                                const SizedBox(height: 16),
                                _buildEditableProfileField("Descripción", userBio.isEmpty ? "Sin biografía aún" : userBio),
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

      // Loading overlay cuando está guardando
      floatingActionButton: _isSaving 
        ? FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.grey,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : null,

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
            onTap: _isSaving ? null : () {
              _editField(label, value);
            },
            child: Icon(
              Icons.chevron_right,
              color: _isSaving ? Colors.grey[300] : Colors.grey[400],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonEditableProfileField(String label, String value) {
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
                    color: Colors.grey[500], // Más claro para indicar que no es editable
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline,
            color: Colors.grey[300],
            size: 20,
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
                  Fluttertoast.showToast(
                    msg: 'Funcionalidad de cámara próximamente disponible',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: const Color(0xFF41277A)), // Color SmartSys
                title: Text("Elegir de galería"),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Funcionalidad de galería próximamente disponible',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editField(String label, String currentValue) {
    // Limpiar el valor actual para campos con texto placeholder
    String initialValue = currentValue;
    if (currentValue.contains("Sin") || currentValue.contains("aún")) {
      initialValue = "";
    }

    TextEditingController controller = TextEditingController(text: initialValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar $label"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: _getHintForField(label),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: label == "Descripción" ? 3 : 1,
            keyboardType: _getKeyboardTypeForField(label),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final newValue = controller.text.trim();
                Navigator.pop(context);
                
                // Validaciones específicas por campo
                if (_validateField(label, newValue)) {
                  _updateProfile(campo: label, nuevoValor: newValue);
                }
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

  String _getHintForField(String label) {
    switch (label) {
      case 'Nombre':
        return 'Ingresa tu nombre completo';
      case 'Teléfono':
        return 'Ej: +503 1234-5678';
      case 'Descripción':
        return 'Cuéntanos un poco sobre ti...';
      default:
        return 'Ingresa tu $label';
    }
  }

  TextInputType _getKeyboardTypeForField(String label) {
    switch (label) {
      case 'Teléfono':
        return TextInputType.phone;
      case 'Descripción':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  bool _validateField(String label, String value) {
    switch (label) {
      case 'Nombre':
        if (value.isEmpty) {
          Fluttertoast.showToast(
            msg: 'El nombre no puede estar vacío',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        }
        if (value.length < 2) {
          Fluttertoast.showToast(
            msg: 'El nombre debe tener al menos 2 caracteres',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        }
        break;
      case 'Teléfono':
        if (value.isNotEmpty && value.length < 8) {
          Fluttertoast.showToast(
            msg: 'Ingresa un número de teléfono válido',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        }
        break;
    }
    return true;
  }
}