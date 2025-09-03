import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/user.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/publications.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_application_1/generated/l10n.dart'; // IMPORTAR PARA TRADUCCIONES

class PublicationsScreen extends StatefulWidget {
  final int? idPlataforma;
  final void Function(Locale locale) onLocaleChange;
  final void Function() onThemeToggle;

  const PublicationsScreen({
    super.key,
    this.idPlataforma,
    required this.onLocaleChange,
    required this.onThemeToggle,
  });

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _idPlataforma;
  Map<String, dynamic>? _platformData;
  bool _isLoading = true;
  List<Publicacion> _publicaciones = [];
  List<dynamic> _asignaciones = [];
  List<dynamic> _personas = [];
  String? _errorMessage;

  // Variable para almacenar el archivo seleccionado
  XFile? _archivoAdjunto;
  User? currentUser;

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          currentUser = user;
        });
        print('✅ Usuario cargado en PublicationsScreen: $currentUser');
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario en PublicationsScreen: $e');
    }
  }

  Widget _buildDefaultPlatformBackground(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor,
            accentColor.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPlatformIcon(Color accentColor) {
    return Icon(
      Icons.account_balance,
      color: accentColor,
      size: 30,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        _idPlataforma = widget.idPlataforma ?? args?['idPlataforma'] ?? 0;
        _platformData = args?['platformData'];
        // Debug: Imprimir los datos recibidos
        print('=== DEBUG PLATFORM DATA ===');
        print('Platform data keys: ${_platformData?.keys.toList()}');
        print('Platform name: ${_platformData?['nombrePlataforma']}');
        print('Has fondoBytes: ${_platformData?['fondoBytes'] != null}');
        print('Has iconoBytes: ${_platformData?['iconoBytes'] != null}');
        print('Has fondoPlataforma: ${_platformData?['fondoPlataforma'] != null}');
        print('Has iconoPlataforma: ${_platformData?['iconoPlataforma'] != null}');
        print('============================');
      });
      _loadData();
    });
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadPublicaciones(),
      _loadAsignaciones(),
      _loadPersonas(),
    ]);
  }

  Future<void> _loadPublicaciones() async {
    try {
      final response = await ApiService.getPublicaciones(
        idPlataforma: _idPlataforma,
      );
      if (response.success && response.data != null) {
        setState(() {
          _publicaciones = response.data!;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = S.of(context).Publications_Load_Error; // TRADUCIDO
      });
    }
  }

  Future<void> _loadAsignaciones() async => setState(() => _asignaciones = []);
  Future<void> _loadPersonas() async => setState(() {
    _personas = [];
    _isLoading = false;
  });

  Color _getPlatformAccentColor() {
    if (_platformData == null) return const Color(0xFF41277A);
    if (_platformData!['privacidadPlataforma'] == 'Privado' ||
        _platformData!['privacidadPlataforma'] == 'Private') {
      return Colors.purple;
    }
    return const Color(0xFF1976D2);
  }

  // Método mejorado para obtener el background
  Uint8List? _getPlatformBackgroundBytes() {
    if (_platformData == null) {
      print('No platform data available');
      return null;
    }

    try {
      // Prioridad 1: fondoBytes (Uint8List directo)
      final fondoBytes = _platformData!['fondoBytes'];
      if (fondoBytes != null) {
        if (fondoBytes is Uint8List && fondoBytes.isNotEmpty) {
          print('✅ Using fondoBytes (${fondoBytes.length} bytes)');
          return fondoBytes;
        }
        print('❌ fondoBytes exists but is not valid Uint8List or is empty');
      }

      // Prioridad 2: fondoPlataforma (string base64 o Uint8List)
      final fondoPlataforma = _platformData!['fondoPlataforma'];
      if (fondoPlataforma != null) {
        if (fondoPlataforma is String && fondoPlataforma.isNotEmpty) {
          try {
            // Limpiar el string base64 de posibles prefijos
            String cleanBase64 = fondoPlataforma;
            if (cleanBase64.startsWith('data:image/')) {
              cleanBase64 = cleanBase64.split(',').last;
            }

            final decoded = base64.decode(cleanBase64);
            print('✅ Using fondoPlataforma string converted to bytes (${decoded.length} bytes)');
            return decoded;
          } catch (e) {
            print('❌ Error decoding base64 background: $e');
            print('❌ Base64 string length: ${fondoPlataforma.length}');
            print('❌ Base64 preview: ${fondoPlataforma.substring(0, 50)}...');
          }
        } else if (fondoPlataforma is Uint8List && fondoPlataforma.isNotEmpty) {
          print('✅ Using fondoPlataforma as Uint8List (${fondoPlataforma.length} bytes)');
          return fondoPlataforma;
        }
        print('❌ fondoPlataforma exists but is not valid format');
      }

      print('❌ No valid background data found in platform data');
      return null;
    } catch (e) {
      print('❌ Exception in _getPlatformBackgroundBytes: $e');
      return null;
    }
  }

  // Método mejorado para obtener el icono
  Uint8List? _getPlatformIconBytes() {
    if (_platformData == null) {
      print('No platform data available for icon');
      return null;
    }

    try {
      // Prioridad 1: iconoBytes (Uint8List directo)
      final iconoBytes = _platformData!['iconoBytes'];
      if (iconoBytes != null) {
        if (iconoBytes is Uint8List && iconoBytes.isNotEmpty) {
          print('✅ Using iconoBytes (${iconoBytes.length} bytes)');
          return iconoBytes;
        }
        print('❌ iconoBytes exists but is not valid Uint8List or is empty');
      }

      // Prioridad 2: iconoPlataforma (string base64 o Uint8List)
      final iconoPlataforma = _platformData!['iconoPlataforma'];
      if (iconoPlataforma != null) {
        if (iconoPlataforma is String && iconoPlataforma.isNotEmpty) {
          try {
            // Limpiar el string base64 de posibles prefijos
            String cleanBase64 = iconoPlataforma;
            if (cleanBase64.startsWith('data:image/')) {
              cleanBase64 = cleanBase64.split(',').last;
            }

            final decoded = base64.decode(cleanBase64);
            print('✅ Using iconoPlataforma string converted to bytes (${decoded.length} bytes)');
            return decoded;
          } catch (e) {
            print('❌ Error decoding base64 icon: $e');
            print('❌ Base64 string length: ${iconoPlataforma.length}');
            print('❌ Base64 preview: ${iconoPlataforma.substring(0, 50)}...');
          }
        } else if (iconoPlataforma is Uint8List && iconoPlataforma.isNotEmpty) {
          print('✅ Using iconoPlataforma as Uint8List (${iconoPlataforma.length} bytes)');
          return iconoPlataforma;
        }
        print('❌ iconoPlataforma exists but is not valid format');
      }

      print('❌ No valid icon data found in platform data');
      return null;
    } catch (e) {
      print('❌ Exception in _getPlatformIconBytes: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildPlatformBanner(accentColor, isDarkMode),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNovedadesTab(),
                  _buildAsignacionesTab(),
                  _buildPersonasTab(),
                ],
              ),
            ),
            _buildBottomTabBar(accentColor, isDarkMode),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // HEADER MEJORADO
  // ---------------------------
  Widget _buildPlatformBanner(Color accentColor, bool isDarkMode) {
    final backgroundBytes = _getPlatformBackgroundBytes();
    final iconBytes = _getPlatformIconBytes();

    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // Imagen de fondo de la plataforma
          Container(
            width: double.infinity,
            height: double.infinity,
            child: backgroundBytes != null
                ? Image.memory(
              backgroundBytes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Error displaying background image: $error');
                return _buildDefaultPlatformBackground(accentColor);
              },
            )
                : _buildDefaultPlatformBackground(accentColor),
          ),
          // Overlay semitransparente para mejor legibilidad
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Contenido del banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                              (route) => false,
                        );
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Icono de la plataforma mejorado
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: iconBytes != null
                            ? Image.memory(
                          iconBytes,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            print('❌ Error displaying icon image: $error');
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.white,
                              child: _buildDefaultPlatformIcon(accentColor),
                            );
                          },
                        )
                            : Container(
                          width: 60,
                          height: 60,
                          color: Colors.white,
                          child: _buildDefaultPlatformIcon(accentColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _platformData?['nombrePlataforma'] ?? S.of(context).Platform_Default_Name, // TRADUCIDO
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _platformData?['descripcionPlataforma'] ?? S.of(context).No_Description, // TRADUCIDO
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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

  // ---------------------------
  // BOTTOM TAB BAR
  // ---------------------------
  Widget _buildBottomTabBar(Color accentColor, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color.fromARGB(255, 65, 65, 65) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabButton(
                icon: Icons.announcement_outlined,
                label: S.of(context).Publications_Tab_News, // TRADUCIDO
                isSelected: _tabController.index == 0,
                onTap: () => _tabController.animateTo(0),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
              _buildTabButton(
                icon: Icons.assignment_outlined,
                label: S.of(context).Publications_Tab_Assignments, // TRADUCIDO
                isSelected: _tabController.index == 1,
                onTap: () => _tabController.animateTo(1),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
              _buildTabButton(
                icon: Icons.people_outlined,
                label: S.of(context).Publications_Tab_People, // TRADUCIDO
                isSelected: _tabController.index == 2,
                onTap: () => _tabController.animateTo(2),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color accentColor,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? accentColor
                  : (isDarkMode ? Colors.white54 : Colors.grey[600]),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? accentColor
                    : (isDarkMode ? Colors.white54 : Colors.grey[600]),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // NOVEDADES TAB
  // ---------------------------
  Widget _buildNovedadesTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: _showCreateAnnouncementDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 65, 65, 65)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: accentColor, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    S.of(context).Publications_New_Announcement, // TRADUCIDO
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: _publicaciones.isEmpty
              ? _buildEmptyState(
            Icons.article_outlined,
            S.of(context).Publications_No_News, // TRADUCIDO
            S.of(context).Publications_News_Subtitle, // TRADUCIDO
          )
              : RefreshIndicator(
            onRefresh: _loadPublicaciones,
            color: accentColor,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _publicaciones.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _showPublicationDetails(_publicaciones[index]),
                child: _buildPublicacionCard(_publicaciones[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicacionCard(Publicacion pub) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();
    final iconBytes = _getPlatformIconBytes();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color.fromARGB(255, 65, 65, 65) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con icono mejorado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: iconBytes != null
                        ? Image.memory(
                      iconBytes,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        print('❌ Error displaying card icon: $error');
                        return Container(
                          width: 40,
                          height: 40,
                          color: Colors.white,
                          child: Icon(
                            Icons.description,
                            color: accentColor,
                            size: 20,
                          ),
                        );
                      },
                    )
                        : Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                      child: Icon(
                        Icons.description,
                        color: accentColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _platformData?['nombrePlataforma'] ?? S.of(context).Platform_Default_Name, // TRADUCIDO
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(pub.fechaPublicacion),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pub.titulo.isNotEmpty)
                  Text(
                    pub.titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  pub.contenido,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                if (pub.archivoAdjunto != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(pub.archivoAdjunto!, fit: BoxFit.cover),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showPublicationDetails(Publicacion pub) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 65, 65, 65)
            : Colors.white,
        title: Text(
          pub.titulo,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pub.contenido,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                ),
              ),
              if (pub.archivoAdjunto != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    pub.archivoAdjunto!,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                "${S.of(context).Publications_Published_On} ${DateFormat('dd/MM/yyyy').format(pub.fechaPublicacion)}", // TRADUCIDO
                style: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(S.of(context).Close, style: TextStyle(color: accentColor)), // TRADUCIDO
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showCreateAnnouncementDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _archivoAdjunto = null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black87,
                            size: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _createAnnouncement(titleController.text, contentController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            S.of(context).Publications_Create_Button, // TRADUCIDO
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title input
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.title,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).Publications_Title_Hint, // TRADUCIDO
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Content input
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: TextField(
                              controller: contentController,
                              decoration: InputDecoration(
                                hintText: S.of(context).Publications_Content_Hint, // TRADUCIDO
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Mostrar imagen seleccionada
                        if (_archivoAdjunto != null) ...[
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_archivoAdjunto!.path),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setStateDialog(() {
                                          _archivoAdjunto = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Attach file button
                        GestureDetector(
                          onTap: () {
                            _showAttachFileOptions(setStateDialog);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _archivoAdjunto != null
                                      ? S.of(context).Publications_Change_Attachment // TRADUCIDO
                                      : S.of(context).Publications_Add_Attachment, // TRADUCIDO
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createAnnouncement(String title, String content) async {
    // Validaciones básicas
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).Publications_Title_Required), // TRADUCIDO
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).Publications_Content_Required), // TRADUCIDO
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Mostrar indicador de carga
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Text(S.of(context).Publications_Creating), // TRADUCIDO
          ],
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      print('Creando anuncio con datos:');
      print('- Título: $title');
      print('- Contenido: $content');
      print('- ID Plataforma: $_idPlataforma');
      print('- Archivo adjunto: ${_archivoAdjunto?.path ?? 'No hay archivo'}');

      // Convertir XFile a File si existe
      File? archivo;
      if (_archivoAdjunto != null) {
        archivo = File(_archivoAdjunto!.path);
        print('- Tamaño del archivo: ${await archivo.length()} bytes');
      }

      // Llamar a la API
      final response = await ApiService.nuevaPublicacion(
        titulo: title.trim(),
        contenido: content.trim(),
        idPlataforma: _idPlataforma,
        idUsuario: currentUser!.idUsuario,
        archivo: archivo,
      );

      // Ocultar el indicador de carga
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      print('Respuesta recibida:');
      print('- Success: ${response.success}');
      print('- Message: ${response.message}');
      print('- Data: ${response.data}');

      if (response.success) {
        // Éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).Publications_Created_Success), // TRADUCIDO
            backgroundColor: _getPlatformAccentColor(),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: S.of(context).Publications_View, // TRADUCIDO
              textColor: Colors.white,
              onPressed: () {
                // Opcional: navegar al anuncio creado
              },
            ),
          ),
        );

        // Limpiar el archivo adjunto después de crear el anuncio
        setState(() {
          _archivoAdjunto = null;
        });

        // Recargar las publicaciones para mostrar el nuevo anuncio
        await _loadPublicaciones();
      } else {
        // Error del servidor
        final errorMessage = response.message ?? S.of(context).Publications_Create_Error; // TRADUCIDO
        print('Error del servidor: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Ocultar el indicador de carga
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      print('Excepción capturada: $e');
      print('Tipo de excepción: ${e.runtimeType}');

      // Error de conexión o excepción
      String errorMessage;
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        errorMessage = S.of(context).Connection_Error; // TRADUCIDO
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = S.of(context).Publications_Timeout_Error; // TRADUCIDO
      } else if (e.toString().contains('FormatException')) {
        errorMessage = S.of(context).Publications_Format_Error; // TRADUCIDO
      } else {
        errorMessage = '${S.of(context).Unexpected_Error}: ${e.toString()}'; // TRADUCIDO
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorMessage),
              if (e.toString().length < 100)
                Text(
                  '${S.of(context).Publications_Error_Detail}: ${e.toString()}', // TRADUCIDO
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: S.of(context).Retry, // TRADUCIDO
            textColor: Colors.white,
            onPressed: () => _createAnnouncement(title, content),
          ),
        ),
      );
    }
  }

  // Función para mostrar opciones de archivo adjunto
  void _showAttachFileOptions([StateSetter? setStateDialog]) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).Publications_Attach_File, // TRADUCIDO
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAttachOption(
                  icon: Icons.photo_library,
                  title: S.of(context).Publications_Gallery, // TRADUCIDO
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    try {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920,
                        maxHeight: 1920,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        setState(() {
                          _archivoAdjunto = image;
                        });
                        // Actualizar el dialog si está abierto
                        if (setStateDialog != null) {
                          setStateDialog(() {
                            _archivoAdjunto = image;
                          });
                        }
                        print('Imagen seleccionada: ${image.path}');
                      }
                    } catch (e) {
                      print('Error al seleccionar imagen: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${S.of(context).Publications_Image_Select_Error}: $e'), // TRADUCIDO
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                _buildAttachOption(
                  icon: Icons.camera_alt,
                  title: S.of(context).Publications_Camera, // TRADUCIDO
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    try {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1920,
                        maxHeight: 1920,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        setState(() {
                          _archivoAdjunto = image;
                        });
                        // Actualizar el dialog si está abierto
                        if (setStateDialog != null) {
                          setStateDialog(() {
                            _archivoAdjunto = image;
                          });
                        }
                        print('Foto tomada: ${image.path}');
                      }
                    } catch (e) {
                      print('Error al tomar foto: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${S.of(context).Publications_Photo_Take_Error}: $e'), // TRADUCIDO
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                _buildAttachOption(
                  icon: Icons.insert_drive_file,
                  title: S.of(context).Publications_Document, // TRADUCIDO
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).Publications_Document_Soon), // TRADUCIDO
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // TABS VACÍOS
  // ---------------------------
  Widget _buildAsignacionesTab() => _buildEmptyState(
    Icons.assignment_outlined,
    S.of(context).Publications_No_Assignments, // TRADUCIDO
    S.of(context).Publications_Assignments_Subtitle, // TRADUCIDO
  );

  Widget _buildPersonasTab() => _buildEmptyState(
    Icons.people_outlined,
    S.of(context).Publications_No_People, // TRADUCIDO
    S.of(context).Publications_People_Subtitle, // TRADUCIDO
  );

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[isDarkMode ? 500 : 400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[isDarkMode ? 400 : 600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}