import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../services/api_service.dart';
import '../models/user.dart';
import 'package:flutter_application_1/generated/l10n.dart';

// Home Screen - Dashboard after login
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required void Function(Locale locale) onLocaleChange,
    required void Function() onThemeToggle,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? userName;
  bool _isLoadingUser = true;
  bool _isLoadingPlatforms = true;
  List<dynamic> _userPlatforms = [];
  String? _errorMessage;
  User? _currentUser;

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
          _currentUser = user;
          userName = user.nombreCompleto;
          _isLoadingUser = false;
        });
        await _loadUserPlatforms();
      } else {
        setState(() {
          userName = "Usuario";
          _isLoadingUser = false;
          _isLoadingPlatforms = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Usuario";
        _isLoadingUser = false;
        _isLoadingPlatforms = false;
        _errorMessage = 'Error cargando datos del usuario';
      });
    }
  }

  Future<void> _loadUserPlatforms() async {
    if (_currentUser == null) return;

    try {
      final result = await ApiService.misPlataformas(
        idUsuario: _currentUser!.idUsuario,
      );

      if (mounted) {
        setState(() {
          if (result.success) {
            _userPlatforms = result.data ?? [];
            _errorMessage = null;
          } else {
            _errorMessage = result.message;
            _userPlatforms = [];
          }
          _isLoadingPlatforms = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error cargando plataformas';
          _userPlatforms = [];
          _isLoadingPlatforms = false;
        });
      }
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

  void _showInstitutionOptions(
    BuildContext context,
    Map<String, dynamic> platform,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(S.of(context).Details),
                onTap: () {
                  Navigator.pop(context);
                  _showPlatformDetails(platform);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title:  Text(S.of(context).Report),
                onTap: () {
                  Navigator.pop(context);
                  // Lógica para reportar plataforma
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title:  Text(S.of(context).Out_Plataform),
                onTap: () {
                  Navigator.pop(context);
                  _showLeavePlatformDialog(platform);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlatformDetails(Map<String, dynamic> platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(platform['nombrePlataforma'] ?? 'Plataforma'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).Description,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(platform['descripcionPlataforma'] ?? 'Sin descripción'),
                SizedBox(height: 8),
                Text(S.of(context).Rol, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(platform['rolUsuarioPlataforma'] ?? 'Sin rol'),
                SizedBox(height: 8),
                Text(
                  S.of(context).Privacy,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(platform['privacidadPlataforma'] ?? 'No definida'),
                SizedBox(height: 8),
                Text(S.of(context).State, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(platform['estadoPlataforma'] ?? 'No definido'),
                if (platform['fechaUnion'] != null) ...[
                  SizedBox(height: 8),
                  Text(
                    S.of(context).Date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(platform['fechaUnion'].toString().split('T')[0]),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(S.of(context).Close),
            ),
          ],
        );
      },
    );
  }

  void _showLeavePlatformDialog(Map<String, dynamic> platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S.of(context).Out_Plataform),
          content: Text(
            '${S.of(context).Message_Out} ${platform['nombrePlataforma']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(S.of(context).Cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Aquí implementarías la lógica para salir de la plataforma
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                     '${S.of(context).Out_Success} ${platform['nombrePlataforma']}',
                    ),
                  ),
                );
              },
              child:  Text( S.of(context).Out , style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with centered logo and notification bell
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/logo_dark.png'
                            : 'assets/logo.png',
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
                ),
                const SizedBox(height: 12),
                Text(
                  S.of(context).Welcome,
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
                // Search box
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
                      hintText: S.of(context).Search,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Mis Plataformas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).MyPlataform,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    if (_isLoadingPlatforms)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Platform list or empty state
                if (_userPlatforms.isEmpty &&
                    !_isLoadingPlatforms &&
                    _errorMessage == null)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).NotPlataform,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).MessageInto,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),

                // Platform cards
                if (_userPlatforms.isNotEmpty)
                  ..._userPlatforms.map(
                    (platform) => Column(
                      children: [
                        _buildPlatformCard(platform),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a explorar plataformas
          Navigator.pushNamed(context, '/institutions');
        },
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
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: '',
          ),
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

  Widget _buildPlatformCard(Map<String, dynamic> platform) {
    // Determinar el color según la privacidad y estado
    Color backgroundColor = Colors.blue[100]!;
    Color accentColor = Colors.blue;

    if (platform['privacidadPlataforma'] == 'Privado' ||
        platform['privacidadPlataforma'] == 'Private') {
      backgroundColor = Colors.purple[100]!;
      accentColor = Colors.purple;
    }

    if (platform['estadoPlataforma'] != 'Activo') {
      backgroundColor = Colors.grey[200]!;
      accentColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header con gradient
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.7), accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icono de la plataforma
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildPlatformIcon(platform, accentColor),
                  ),
                  const SizedBox(width: 12),
                  // Información de la plataforma
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          platform['nombrePlataforma'] ?? 'Sin nombre',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          platform['rolUsuarioPlataforma'] ?? 'Sin rol',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de opciones
                  GestureDetector(
                    onTap: () => _showInstitutionOptions(context, platform),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (platform['descripcionPlataforma'] != null &&
                    platform['descripcionPlataforma'].toString().isNotEmpty)
                  Text(
                    platform['descripcionPlataforma'],
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      platform['privacidadPlataforma'] ?? 'Sin definir',
                      platform['privacidadPlataforma'] == 'Privado' ||
                              platform['privacidadPlataforma'] == 'Private'
                          ? Icons.lock
                          : Icons.public,
                      accentColor,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      platform['estadoPlataforma'] ?? 'Sin estado',
                      platform['estadoPlataforma'] == 'Activo'
                          ? Icons.check_circle
                          : Icons.pause_circle,
                      platform['estadoPlataforma'] == 'Activo'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon(Map<String, dynamic> platform, Color accentColor) {
    try {
      final iconoData = platform['iconoPlataforma'];

      if (iconoData != null) {
        // Si es una cadena base64, convertirla
        if (iconoData is String) {
          final bytes = base64.decode(iconoData);
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.account_balance,
                  color: accentColor,
                  size: 24,
                );
              },
            ),
          );
        }
        // Si ya es Uint8List
        else if (iconoData is Uint8List) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              iconoData,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.account_balance,
                  color: accentColor,
                  size: 24,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      print('Error loading platform icon: $e');
    }

    // Fallback icon
    return Icon(Icons.account_balance, color: accentColor, size: 24);
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
