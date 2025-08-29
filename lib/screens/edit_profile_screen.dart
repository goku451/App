import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required void Function(Locale locale) onLocaleChange,
    required void Function() onThemeToggle,
  });

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
  String userLastName = "";
  String userName = "Usuario";
  String userEmail = "email@example.com";
  String userPhone = "";
  String userBio = "";
  String userCodigoUnico = "";

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
          userName = user.nombre;
          userLastName = user.apellido;
          userEmail = user.correoElectronico;
          userCodigoUnico = user.codigoUnico;
          userPhone = user.telefono ?? "";
          userBio = user.biografia ?? "";
          _isLoadingUser = false;
        });
        print('✅ Usuario cargado en EditProfile: $userCodigoUnico');
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
          nombre = nuevoValor;
          break;
        case 'Apellido':
          apellido = nuevoValor;
          break;
        case 'Teléfono':
          telefono = nuevoValor.isEmpty ? null : nuevoValor;
          userPhone = nuevoValor;
          break;
        case 'Descripción':
          biografia = nuevoValor.isEmpty ? null : nuevoValor;
          userBio = nuevoValor;
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
          userName = response.data!.nombre;
          userLastName = response.data!.apellido;
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

        print('✅ Perfil actualizado Goku: ${response.data!.nombreCompleto}');
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
        Navigator.pushNamed(
          context,
          '/institutions',
        ); // ✅ NUEVO - Navega a instituciones
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
                S.of(context).Edit,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),

              // Profile form
              Expanded(
                child: Container(
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
                  padding: EdgeInsets.all(20),
                  child:
                  _isLoadingUser
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF41277A),
                        ),
                        SizedBox(height: 16),
                        Text(
                          S.of(context).Message_Load,
                          style: TextStyle(
                            color: Colors.grey[isDarkMode ? 400 : 600],
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
                              radius: 40,
                              backgroundImage:
                              currentUser?.fotoBytes != null
                                  ? MemoryImage(
                                currentUser!.fotoBytes!,
                              )
                                  : const AssetImage(
                                'assets/plat.png',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                // Handle change picture
                                _showImagePicker();
                              },
                              child: Text(
                                S.of(context).Change_Photo,
                                style: TextStyle(
                                  color: const Color(
                                    0xFF41277A,
                                  ), // Color SmartSys
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
                          S.of(context).About_me,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[isDarkMode ? 400 : 700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form fields
                      Expanded(
                        child: ListView(
                          children: [
                            _buildEditableProfileField(
                              S.of(context).Name,
                              userName,
                            ),
                            const SizedBox(height: 16),
                            _buildEditableProfileField(
                              S.of(context).Last_Name,
                              userLastName,
                            ),
                            const SizedBox(height: 16),
                            _buildNonEditableProfileField(
                              S.of(context).Email,
                              userEmail,
                            ),
                            const SizedBox(height: 16),
                            _buildNonEditableProfileField(
                              S.of(context).Codigo,
                              userCodigoUnico,
                            ),
                            const SizedBox(height: 16),
                            _buildEditableProfileField(
                              S.of(context).Phone,
                              userPhone.isEmpty
                                  ? S.of(context).OutPhone
                                  : userPhone,
                            ),
                            const SizedBox(height: 16),
                            _buildEditableProfileField(
                              S.of(context).Description,
                              userBio.isEmpty
                                  ? S.of(context).Message_Bio
                                  : userBio,
                            ),
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
      floatingActionButton:
      _isSaving
          ? FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.grey,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : null,

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

  Widget _buildEditableProfileField(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[isDarkMode ? 600 : 300]!,
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
                    color: Colors.grey[isDarkMode ? 400 : 600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          GestureDetector(
            onTap:
            _isSaving
                ? null
                : () {
              _editField(label, value);
            },
            child: Icon(
              Icons.chevron_right,
              color: _isSaving
                  ? Colors.grey[300]
                  : Colors.grey[400],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonEditableProfileField(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[isDarkMode ? 600 : 300]!,
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
                    color: Colors.grey[isDarkMode ? 400 : 600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[isDarkMode ? 500 : 500], // Más claro para indicar que no es editable
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline,
            color: Colors.grey[isDarkMode ? 500 : 300],
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showImagePicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
          : Colors.white, // blanco en modo claro
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
                S.of(context).Change_Photo_Message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF41277A)),
                title: Text(
                  S.of(context).Take_a_Pictura,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: S.of(context).Message_Future,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF41277A)),
                title: Text(
                  S.of(context).Chose_galery,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Cierra el modal

                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null && currentUser != null) {
                    final response = await ApiService.updateProfileWithPhoto(
                      idUsuario: currentUser!.idUsuario,
                      pickedFile: pickedFile,
                    );

                    if (response.success) {
                      setState(() {
                        currentUser = response.data;
                      });
                      Fluttertoast.showToast(
                        msg: S.of(context).Message_Edit_Photo,
                      );
                    } else {
                      Fluttertoast.showToast(msg: response.message);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editField(String label, String currentValue) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Limpiar el valor actual para campos con texto placeholder
    String initialValue = currentValue;
    if (currentValue.contains("Sin") || currentValue.contains("aún")) {
      initialValue = "";
    }

    TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
              : Colors.white, // blanco en modo claro
          title: Text(
            "${S.of(context).Edit} $label",
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: _getHintForField(label),
              hintStyle: TextStyle(
                color: Colors.grey[isDarkMode ? 400 : 600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[isDarkMode ? 600 : 400]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[isDarkMode ? 600 : 400]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFF41277A),
                ),
              ),
            ),
            maxLines: label == S.of(context).Description ? 3 : 1,
            keyboardType: _getKeyboardTypeForField(label),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).Cancel,
                style: TextStyle(
                  color: Colors.grey[isDarkMode ? 400 : 600],
                ),
              ),
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
              child: Text(S.of(context).Save),
            ),
          ],
        );
      },
    );
  }

  String _getHintForField(String label) {
    switch (label) {
      case 'Nombre':
        return S.of(context).IntoName;
      case 'Teléfono':
        return 'Ej: +503 1234-5678';
      case 'Descripción':
        return S.of(context).Message_Bio;
      default:
        return '${S.of(context).Insert_to} $label';
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
            msg: S.of(context).Error_Name,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        }
        if (value.length < 2) {
          Fluttertoast.showToast(
            msg: S.of(context).Error_Name2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return false;
        }
        break;
      case 'Teléfono':
        if (value.isNotEmpty && value.length < 8) {
          Fluttertoast.showToast(
            msg: S.of(context).Error_Phone,
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