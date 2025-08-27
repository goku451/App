import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int? _expandedIndex;

  final List<Map<String, String>> _helpItems = [
    {
      'title': 'Crear una cuenta',
      'content': 'Para crear una cuenta en nuestra plataforma, dirígete a la pantalla de registro donde deberás proporcionar tu nombre completo, correo electrónico válido y crear una contraseña segura. Una vez completados estos datos, recibirás un correo de verificación que deberás confirmar para activar tu cuenta.',
    },
    {
      'title': 'Verificar correo electrónico',
      'content': 'Después de registrarte, es importante verificar tu correo electrónico para activar todas las funcionalidades de tu cuenta. Revisa tu bandeja de entrada y busca el correo de verificación. Si no lo encuentras, revisa la carpeta de spam. Haz clic en el enlace de verificación para completar el proceso.',
    },
    {
      'title': 'Chatear',
      'content': 'Para iniciar un chat con otro usuario, necesitarás su código único. Cada usuario tiene un código personal que debe compartir contigo. Ve al apartado de Chat, ingresa el código único del usuario con quien deseas conversar y se creará automáticamente un nuevo chat privado entre ustedes.',
    },
    {
      'title': 'Configurar tu perfil',
      'content': 'Personaliza tu perfil accediendo a la configuración desde el menú principal. Aquí podrás agregar una foto de perfil, escribir una biografía, actualizar tu información personal y configurar tus preferencias de privacidad. Un perfil completo te ayudará a conectar mejor con otros usuarios.',
    },
  ];

  List<Map<String, String>> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _helpItems;
    }
    return _helpItems
        .where((item) =>
    item['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item['content']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Centro de ayuda',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF41277A).withOpacity(0.8),
                      const Color(0xFF41277A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Centro de Ayuda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Hola! ¿En qué podemos ayudarte?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Search box
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 65, 65, 65)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar ayuda...',
                    hintStyle: TextStyle(
                      color: Colors.grey[isDarkMode ? 400 : 400],
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[isDarkMode ? 400 : 400],
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[isDarkMode ? 400 : 400],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = "";
                          _expandedIndex = null;
                        });
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _expandedIndex = null; // Reset expanded state when searching
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Articles section
              Text(
                'Artículos populares',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 16),

              // Help items
              if (filteredItems.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 65, 65, 65)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[isDarkMode ? 500 : 400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron resultados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[isDarkMode ? 400 : 600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otros términos de búsqueda',
                        style: TextStyle(
                          color: Colors.grey[isDarkMode ? 500 : 500],
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredItems.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isExpanded = _expandedIndex == index;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 65, 65, 65)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF41277A).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _getIconForTitle(item['title']!),
                                      color: const Color(0xFF41277A),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item['title']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).textTheme.titleLarge?.color,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey[isDarkMode ? 400 : 600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: isExpanded ? null : 0,
                            child: isExpanded
                                ? Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: Colors.grey[isDarkMode ? 600 : 300],
                                    thickness: 0.5,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    item['content']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'crear una cuenta':
        return Icons.person_add;
      case 'verificar correo electrónico':
        return Icons.mark_email_read;
      case 'chatear':
        return Icons.chat_bubble;
      case 'configurar tu perfil':
        return Icons.settings;
      default:
        return Icons.help;
    }
  }
}