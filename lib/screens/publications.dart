import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/publications.dart';
import 'package:flutter_application_1/generated/l10n.dart';

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

class _PublicationsScreenState extends State<PublicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _idPlataforma;
  Map<String, dynamic>? _platformData;
  bool _isLoading = true;
  List<Publicacion> _publicaciones = [];
  List<dynamic> _asignaciones = [];
  List<dynamic> _inventario = [];
  List<dynamic> _personas = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        _idPlataforma = widget.idPlataforma ?? args?['idPlataforma'] ?? 0;
        _platformData = args?['platformData'];
      });
      _loadData();
    });
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
      _loadInventario(),
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
        _errorMessage = "Error al cargar publicaciones: $e";
      });
    }
  }

  Future<void> _loadAsignaciones() async {
    setState(() {
      _asignaciones = [];
    });
  }

  Future<void> _loadInventario() async {
    setState(() {
      _inventario = [];
    });
  }

  Future<void> _loadPersonas() async {
    setState(() {
      _personas = [];
      _isLoading = false;
    });
  }

  Color _getPlatformAccentColor() {
    if (_platformData == null) return const Color(0xFF41277A);

    if (_platformData!['privacidadPlataforma'] == 'Privado' ||
        _platformData!['privacidadPlataforma'] == 'Private') {
      return Colors.purple;
    }
    return const Color(0xFF1976D2); // Azul para públicas
  }

  // Método para obtener los bytes de la imagen de fondo (igual que institutions)
  Uint8List? _getPlatformBackgroundBytes() {
    if (_platformData == null) return null;

    try {
      // Intentar primero con el formato de institutions
      final fondoBytes = _platformData!['fondoBytes'];
      if (fondoBytes != null && fondoBytes is Uint8List) {
        return fondoBytes;
      }

      // Fallback al formato anterior
      final fondoData = _platformData!['fondoPlataforma'];
      if (fondoData != null) {
        if (fondoData is String) {
          return base64.decode(fondoData);
        } else if (fondoData is Uint8List) {
          return fondoData;
        }
      }
    } catch (e) {
      print('Error loading platform background: $e');
    }
    return null;
  }

  // Método para obtener los bytes del icono (igual que institutions)
  Uint8List? _getPlatformIconBytes() {
    if (_platformData == null) return null;

    try {
      // Intentar primero con el formato de institutions
      final iconoBytes = _platformData!['iconoBytes'];
      if (iconoBytes != null && iconoBytes is Uint8List) {
        return iconoBytes;
      }

      // Fallback al formato anterior
      final iconoData = _platformData!['iconoPlataforma'];
      if (iconoData != null) {
        if (iconoData is String) {
          return base64.decode(iconoData);
        } else if (iconoData is Uint8List) {
          return iconoData;
        }
      }
    } catch (e) {
      print('Error loading platform icon: $e');
    }
    return null;
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
            // Header con banner de la plataforma
            _buildPlatformBanner(accentColor, isDarkMode),

            // Contenido principal expandido
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNovedadesTab(),
                  _buildAsignacionesTab(),
                  _buildInventarioTab(),
                  _buildPersonasTab(),
                ],
              ),
            ),

            // Barra de navegación inferior personalizada
            _buildBottomTabBar(accentColor, isDarkMode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int currentTab = _tabController.index;
          switch (currentTab) {
            case 0:
            // Crear nueva publicación
              _showCreateAnnouncementDialog();
              break;
            case 1:
            // Nueva asignación
              break;
            case 2:
            // Nuevo elemento inventario
              break;
            case 3:
            // Invitar persona
              break;
          }
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPlatformBanner(Color accentColor, bool isDarkMode) {
    final backgroundBytes = _getPlatformBackgroundBytes();
    final iconBytes = _getPlatformIconBytes();

    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // Imagen de fondo o gradiente por defecto
          Container(
            width: double.infinity,
            height: double.infinity,
            child: backgroundBytes != null
                ? Image.memory(
              backgroundBytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultBackground(accentColor);
              },
            )
                : _buildDefaultBackground(accentColor),
          ),

          // Overlay oscuro
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

          // Contenido del header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Barra superior con botón atrás y menú
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        // Mostrar menú de opciones
                      },
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Información de la plataforma
                Row(
                  children: [
                    // Icono de la plataforma
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: iconBytes != null
                            ? Image.memory(
                          iconBytes,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.account_balance,
                              color: accentColor,
                              size: 30,
                            );
                          },
                        )
                            : Icon(
                          Icons.account_balance,
                          color: accentColor,
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Información textual
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _platformData?['nombrePlataforma'] ?? 'Plataforma',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _platformData?['descripcionPlataforma'] ?? 'Sin descripción',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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

  Widget _buildDefaultBackground(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor,
            accentColor.withOpacity(0.8),
          ],
        ),
      ),
    );
  }

  // Barra de navegación inferior personalizada
  Widget _buildBottomTabBar(Color accentColor, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color.fromARGB(255, 65, 65, 65)
            : Colors.white,
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
                label: 'Novedades',
                isSelected: _tabController.index == 0,
                onTap: () => _tabController.animateTo(0),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
              _buildTabButton(
                icon: Icons.assignment_outlined,
                label: 'Asignaciones',
                isSelected: _tabController.index == 1,
                onTap: () => _tabController.animateTo(1),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
              _buildTabButton(
                icon: Icons.inventory_outlined,
                label: 'Inventario',
                isSelected: _tabController.index == 2,
                onTap: () => _tabController.animateTo(2),
                accentColor: accentColor,
                isDarkMode: isDarkMode,
              ),
              _buildTabButton(
                icon: Icons.people_outline,
                label: 'Personas',
                isSelected: _tabController.index == 3,
                onTap: () => _tabController.animateTo(3),
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
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
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

  Widget _buildNovedadesTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        // Botón "Nuevo anuncio" estilo Classroom
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
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                ),
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
                  Icon(
                    Icons.edit,
                    color: accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nuevo anuncio',
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

        // Lista de publicaciones
        Expanded(
          child: _publicaciones.isEmpty
              ? _buildEmptyState(
            Icons.article_outlined,
            'No hay novedades',
            'Las publicaciones aparecerán aquí',
          )
              : RefreshIndicator(
            onRefresh: _loadPublicaciones,
            color: accentColor,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _publicaciones.length,
              itemBuilder: (context, index) {
                return _buildPublicacionCard(_publicaciones[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAsignacionesTab() {
    return _buildEmptyState(
      Icons.assignment_outlined,
      'No hay asignaciones',
      'Las tareas y trabajos aparecerán aquí',
    );
  }

  Widget _buildInventarioTab() {
    return _buildEmptyState(
      Icons.inventory_outlined,
      'No hay elementos en inventario',
      'Los recursos y materiales aparecerán aquí',
    );
  }

  Widget _buildPersonasTab() {
    return _buildEmptyState(
      Icons.people_outlined,
      'No hay personas',
      'Los miembros de la plataforma aparecerán aquí',
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[isDarkMode ? 500 : 400],
            ),
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
              style: TextStyle(
                color: Colors.grey[isDarkMode ? 500 : 500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicacionCard(Publicacion pub) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();
    final iconBytes = _getPlatformIconBytes();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color.fromARGB(255, 65, 65, 65)
            : Colors.white,
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
          // Header de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icono de la plataforma
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: iconBytes != null
                        ? Image.memory(
                      iconBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.description,
                          color: accentColor,
                          size: 20,
                        );
                      },
                    )
                        : Icon(
                      Icons.description,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _platformData?['nombrePlataforma'] ?? 'Plataforma',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      Text(
                        pub.fechaPublicacion.toString().split('T')[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // Mostrar opciones de la publicación
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de la publicación
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
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Área de comentarios
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                // Abrir comentarios
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Agregar un comentario de clase',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAnnouncementDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getPlatformAccentColor();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 65, 65, 65)
              : Colors.white,
          title: Text(
            'Crear anuncio',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'Función próximamente disponible',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
}