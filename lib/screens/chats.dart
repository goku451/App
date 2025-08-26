import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../screens/chat_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({
    super.key,
    required void Function(Locale locale) onLocaleChange,
    required void Function() onThemeToggle,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  User? currentUser;
  int _selectedIndex = 1;
  List<ChatItem> allChats = [];
  bool _isLoadingChats = true;
  bool _isLoadingUser = true;
  int _selectedTab = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) => _loadChats());
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      if (mounted) {
        setState(() {
          currentUser = user;
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      print("❌ Error cargando usuario en ChatScreen: $e");
      setState(() => _isLoadingUser = false);
    }
  }

  Future<void> _loadChats() async {
    if (currentUser == null) return;

    setState(() => _isLoadingChats = true);

    final response = await ApiService.fetchUserChats(currentUser!.idUsuario);
    print("Respuesta de la API: ${response.data}");
    if (response.success && response.data != null) {
      List<ChatItem> fetchedChats =
          response.data!.map((chatJson) {
            return ChatItem.fromJson(chatJson, currentUser!.idUsuario);
          }).toList();

      setState(() {
        allChats = fetchedChats;
        _isLoadingChats = false;
      });
    } else {
      setState(() => _isLoadingChats = false);
      print("❌ Error cargando chats: ${response.message}");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home'); // Navega a home
        break;
      case 1:
        // Already on chats screen
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
        Navigator.pushNamed(context, '/settings'); // Navega a configuración
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255, 255),
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
                  // Centered logo only
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
                                ? Colors
                                    .white // color en modo oscuro
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

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              _selectedTab == 0
                                  ? const Color(0xFF3A294B)
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          S.of(context).All_Chats,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                _selectedTab == 0
                                    ? Colors.white
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(179, 0, 0, 0)
                                        : Colors.grey[600]),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar with rounded corners like mockup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[500], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: S.of(context).Search_Chats,
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Chats list
            Expanded(child: _buildCurrentTabContent()),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _NuevoChat();
        },
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(
                  255,
                  65,
                  65,
                  65,
                ) // gris oscuro en modo oscuro
                : Colors.white, // blanco en modo claro,
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

  Widget _buildCurrentTabContent() {
    List<ChatItem> chats = allChats;

    if (_searchQuery.isNotEmpty) {
      chats =
          chats.where((chat) {
            return chat.name.toLowerCase().contains(_searchQuery) ||
                chat.lastMessage.toLowerCase().contains(_searchQuery);
          }).toList();
    }

    if (_isLoadingChats)
      return const Center(child: CircularProgressIndicator());

    if (chats.isEmpty) return Center(child: Text("${S.of(context).No_Chats}"));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: chats.length,
      itemBuilder: (context, index) => _buildChatItem(chats[index]),
    );
  }

  void _NuevoChat() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: no hay usuario activo")),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).Create_Chat),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "${S.of(context).Chat_Name}",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "${S.of(context).Codigo_User}",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).Cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await ApiService.nuevochat(
                    idUsuario: currentUser!.idUsuario,
                    nombre: nameController.text.trim(),
                    codigoUnico: codeController.text.trim(),
                  );

                  if (response.success && response.data != null) {
                    Navigator.pop(context);

                    final idChat = response.data!.idChat;
                    final idUsuarioEmisor = response.data!.idUsuarioEmisor;
                    final idUsuarioReceptor = response.data!.idUsuarioReceptor;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatUser(
                              idChat: idChat,
                              idUsuarioEmisor: idUsuarioEmisor,
                              idUsuarioReceptor: idUsuarioReceptor,
                              nombreUsuarioReceptor: nameController.text.trim(),
                            ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.message ?? "Error al crear chat",
                        ),
                      ),
                    );
                  }
                },
                child: Text(S.of(context).Join),
              ),
            ],
          ),
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return GestureDetector(
      onTap: () {
        if (currentUser == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatUser(
                  idChat: chat.idChat,
                  idUsuarioEmisor: currentUser!.idUsuario,
                  idUsuarioReceptor: chat.idUsuario ?? 0,
                  nombreUsuarioReceptor: chat.name,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            // Avatar
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: chat.avatarColor,
              ),
              child:
                  chat.avatarImage != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.memory(
                          base64Decode(chat.avatarImage!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _avatarFallback(chat);
                          },
                        ),
                      )
                      : _avatarFallback(chat),
            ),

            const SizedBox(width: 12),
            // Chat content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF41277A),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              chat.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(ChatItem chat) {
    return Center(
      child:
          chat.avatarIcon != null
              ? Icon(chat.avatarIcon, color: Colors.white, size: 24)
              : Text(
                chat.avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
    );
  }
}

class ChatItem {
  final int idChat;
  final int? idUsuario; // agrega esto
  final String name;
  final String lastMessage;
  final String avatarLetter;
  final String? avatarImage;
  final IconData? avatarIcon;
  final Color avatarColor;
  final int unreadCount;
  final String type;

  ChatItem({
    this.idUsuario, // nuevo
    required this.idChat,
    required this.name,
    required this.lastMessage,
    this.avatarLetter = '?',
    this.avatarImage,
    this.avatarIcon,
    this.avatarColor = Colors.grey,
    this.unreadCount = 0,
    this.type = 'normal',
  });

  factory ChatItem.fromJson(Map<String, dynamic> json, int idUsuarioActual) {
    int idEmisor =
        int.tryParse(json['idUsuarioEmisor']?.toString() ?? '0') ?? 0;
    int idReceptor =
        int.tryParse(json['idUsuarioReceptor']?.toString() ?? '0') ?? 0;
    bool soyEmisor = idEmisor == idUsuarioActual;

    return ChatItem(
      idChat: int.tryParse(json['idChat']?.toString() ?? '0') ?? 0,
      idUsuario: soyEmisor ? idReceptor : idEmisor,
      name:
          "${json['nombreUsuarioReceptor'] ?? ''} ${json['apellidoUsuarioReceptor'] ?? ''}"
              .trim(),
      lastMessage: json['ultimoMensaje'] ?? '',
      avatarLetter: '?',
      avatarImage: json['fotoPerfil'],
      avatarColor: Colors.grey,
      unreadCount: json['totalMensajes'] ?? 0,
      type: json['tipo'] ?? 'personal',
    );
  }
}