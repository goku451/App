import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/platform.dart';
import 'package:flutter_application_1/generated/l10n.dart';

class InstitutionsScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  final void Function() onThemeToggle;

  const InstitutionsScreen({
    super.key,
    required this.onLocaleChange,
    required this.onThemeToggle,
  });

  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  int _selectedIndex = 2; // Institutions tab selected
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Plataforma> _plataformas = [];
  List<Plataforma> _plataformasFiltradas = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarPlataformas();
  }

  Future<void> _cargarPlataformas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await ApiService.plataformasActivas();

      if (response.success && response.data != null) {
        final List<Plataforma> plataformas =
        response.data!
            .map<Plataforma>((json) => Plataforma.fromJson(json))
            .toList();

        setState(() {
          _plataformas = plataformas;
          _plataformasFiltradas = plataformas;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${S.of(context).Connection_Error}: $e';
        _isLoading = false;
      });
    }
  }

  void _filtrarPlataformas(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _plataformasFiltradas = _plataformas;
      } else {
        _plataformasFiltradas = _plataformas
            .where(
              (plataforma) =>
          plataforma.nombrePlataforma.toLowerCase().contains(
            _searchQuery,
          ) ||
              (plataforma.descripcionPlataforma?.toLowerCase().contains(
                _searchQuery,
              ) ??
                  false),
        )
            .toList();
      }
    });
  }

  Future<void> _buscarEnServidor() async {
    if (_searchQuery.trim().isEmpty) {
      _cargarPlataformas();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.explorarPlataformas(
        busqueda: _searchQuery,
      );

      if (response.success && response.data != null) {
        final List<Plataforma> plataformas = response.data!
            .map<Plataforma>((json) => Plataforma.fromJson(json))
            .toList();

        setState(() {
          _plataformasFiltradas = plataformas;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${S.of(context).Search_Error}: $e';
        _isLoading = false;
      });
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

  void _showInstitutionOptions(BuildContext context, Plataforma plataforma) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
          : Colors.white, // blanco en modo claro
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.report,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black54,
                ),
                title: Text(
                  S.of(context).Report_Platform,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _reportarPlataforma(plataforma);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black54,
                ),
                title: Text(
                  S.of(context).Information,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarInformacion(plataforma);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.join_inner,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black54,
                ),
                title: Text(
                  S.of(context).Join_Platform,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _unirseAPlataforma(plataforma);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _reportarPlataforma(Plataforma plataforma) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.of(context).Reporting} ${plataforma.nombrePlataforma}...')),
    );
  }

  void _mostrarInformacion(Plataforma plataforma) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
              : Colors.white, // blanco en modo claro
          title: Text(
            plataforma.nombrePlataforma,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${S.of(context).Description} ${plataforma.descripcionPlataforma ?? S.of(context).No_Description_Available}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${S.of(context).Privacy} ${plataforma.privacidadPlataforma}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${S.of(context).Capacity} ${plataforma.capacidadMiembros} ${S.of(context).Members}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${S.of(context).State} ${plataforma.estadoPlataforma}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                S.of(context).Close,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF41277A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _unirseAPlataforma(Plataforma plataforma) async {
    try {
      final user = await ApiService.getCurrentUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).User_Not_Found_Error)),
        );
        return;
      }

      if (plataforma.privacidadPlataforma.toLowerCase() == "publica" ||
          plataforma.privacidadPlataforma.toLowerCase() == "público") {
        // Unirse a plataforma pública directamente
        final response = await ApiService.joinPublicPlatform(
          idUsuario: user.idUsuario,
          idPlataforma: plataforma.idPlataforma,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? "${S.of(context).Joined_Platform} ${plataforma.nombrePlataforma}"),
              backgroundColor: response.success ? Colors.green : Colors.red,
            ),
          );
        }
      } else {
        // Mostrar diálogo para código de plataforma privada
        _mostrarDialogoCodigoPrivado(plataforma, user.idUsuario);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).Join_Error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarDialogoCodigoPrivado(Plataforma plataforma, int idUsuario) {
    String codigo = "";
    final TextEditingController codigoController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
              : Colors.white, // blanco en modo claro
          title: Text(
            "${S.of(context).Join_To} ${plataforma.nombrePlataforma}",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).Private_Platform_Message,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codigoController,
                onChanged: (value) => codigo = value,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: S.of(context).Access_Code,
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFF41277A),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                obscureText: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                S.of(context).Cancel,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF41277A),
              ),
              child: Text(
                S.of(context).Join,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.pop(ctx); // Cerrar diálogo

                if (codigo.trim().isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).Valid_Code_Required),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }

                // Mostrar indicador de carga
                if (mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF41277A),
                      ),
                    ),
                  );
                }

                try {
                  final response = await ApiService.joinPrivatePlatform(
                    idUsuario: idUsuario,
                    idPlataforma: plataforma.idPlataforma,
                    codigo: codigo.trim(),
                  );

                  if (mounted) {
                    Navigator.pop(context); // Cerrar indicador de carga

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.message ?? S.of(context).Join_Error),
                        backgroundColor: response.success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context); // Cerrar indicador de carga
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${S.of(context).Join_Error}: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with centered logo and notification bell
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Empty container for spacing
                  const SizedBox(width: 24),
                  // Centered logo only - optimal size
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
                  // Notification bell with red dot
                  Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // color en modo oscuro
                            : Colors.black54, // color en modo claro
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

            // Search bar with rounded corners
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
                      : Colors.white, // blanco en modo claro
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.3) // sombra más fuerte en modo oscuro
                          : Colors.black.withOpacity(0.05), // sombra más suave en modo claro
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filtrarPlataformas,
                  onSubmitted: (_) => _buscarEnServidor(),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: S.of(context).Search_Platform,
                    hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.grey[400],
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.grey[400],
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.grey[400],
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filtrarPlataformas('');
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title and refresh button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? S.of(context).Active_Platforms
                        : S.of(context).Search_Results,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: _cargarPlataformas,
                    icon: Icon(
                      Icons.refresh,
                      color: const Color(0xFF41277A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content area
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF41277A),
                ),
              )
                  : _errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _cargarPlataformas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF41277A),
                      ),
                      child: Text(
                        S.of(context).Retry,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
                  : _plataformasFiltradas.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchQuery.isEmpty
                          ? S.of(context).No_Platforms_Available
                          : '${S.of(context).No_Results_Found} "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _cargarPlataformas,
                color: const Color(0xFF41277A),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _plataformasFiltradas.length,
                  itemBuilder: (context, index) {
                    final plataforma = _plataformasFiltradas[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildPlataformaBannerCard(plataforma),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).Create_Platform_Feature),
            ),
          );
        },
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 65, 65, 65) // gris oscuro en modo oscuro
            : Colors.white, // blanco en modo claro
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
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white54 // gris claro en modo oscuro
            : Colors.grey[400], // gris en modo claro
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  // Widget para el banner de plataforma con datos dinámicos
  Widget _buildPlataformaBannerCard(Plataforma plataforma) {
    return GestureDetector(
        onTap: () => _unirseAPlataforma(plataforma),
        child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3) // sombra más fuerte en modo oscuro
                      : Colors.black.withOpacity(0.1), // sombra más suave en modo claro
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
                  child: plataforma.fondoBytes != null
                      ? Image.memory(
                    plataforma.fondoBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultBackground();
                    },
                  )
                      : _buildDefaultBackground(),
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
                              plataforma.nombrePlataforma,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plataforma.descripcionPlataforma ?? S.of(context).No_Description_Available,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Avatar/Icono de la plataforma
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: plataforma.iconoBytes != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.memory(
                            plataforma.iconoBytes!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultIcon();
                            },
                          ),
                        )
                            : _buildDefaultIcon(),
                      ),
                    ],
                  ),
                ),
// Estado de la plataforma
                    if (plataforma.estadoPlataforma != 'Activo')
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: plataforma.estadoPlataforma == 'Inactivo'
                                ? Colors.red.withOpacity(0.8)
                                : Colors.orange.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            plataforma.estadoPlataforma,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Indicador de privacidad
                    Positioned(
                      top: 8,
                      right: 40,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          plataforma.privacidadPlataforma.toLowerCase() == 'público' ||
                              plataforma.privacidadPlataforma.toLowerCase() == 'public' ||
                              plataforma.privacidadPlataforma.toLowerCase() == 'publica'
                              ? Icons.public
                              : Icons.lock,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    // Botón de opciones (3 puntos)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _showInstitutionOptions(context, plataforma),
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
        ),
    );
  }

  Widget _buildDefaultBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF41277A),
            const Color(0xFF41277A).withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return const Icon(
      Icons.account_balance,
      color: Color(0xFF41277A),
      size: 30,
    );
  }
}