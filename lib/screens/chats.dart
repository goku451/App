import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 1;
  int _selectedTab = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        Navigator.pushNamed(context, '/institutions'); // ✅ NUEVO - Navega a instituciones
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with centered logo and notification bell
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
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
                          color: _selectedTab == 0 ? const Color(0xFF3A294B) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Todos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedTab == 0 ? Colors.white : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? const Color(0xFF3A294B) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Grupos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedTab == 1 ? Colors.white : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 2),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 2 ? const Color(0xFF3A294B) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Institución',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedTab == 2 ? Colors.white : Colors.grey[600],
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                          hintText: 'Buscar en tus chats',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
            Expanded(
              child: _buildCurrentTabContent(),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
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
    List<ChatItem> chats = [];

    if (_selectedTab == 0) {
      // Todos: mostrar todos los chats
      chats = _getAllChats();
    } else if (_selectedTab == 1) {
      // Grupos: totopia
      chats = _getGroupChats();
    } else {
      // Instituciones: dulce nube
      chats = _getInstitutionChats();
    }

    // Filtrar chats basándose en la búsqueda
    if (_searchQuery.isNotEmpty) {
      chats = chats.where((chat) {
        return chat.name.toLowerCase().contains(_searchQuery) ||
            chat.lastMessage.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (chats.isEmpty && _searchQuery.isNotEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No se encontraron chats',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Intenta con otro término de búsqueda',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatItem(chat);
      },
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: chat.avatarColor,
            ),
            child: chat.avatarImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                chat.avatarImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: chat.avatarColor,
                    ),
                    child: Center(
                      child: chat.avatarIcon != null
                          ? Icon(
                        chat.avatarIcon,
                        color: Colors.white,
                        size: 24,
                      )
                          : Text(
                        chat.avatarLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Center(
              child: chat.avatarIcon != null
                  ? Icon(
                chat.avatarIcon,
                color: Colors.white,
                size: 24,
              )
                  : Text(
                chat.avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
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
    );
  }

  // Método para obtener TODOS los chats
  List<ChatItem> _getAllChats() {
    return [
      ChatItem(
        name: 'Daniel Valencia',
        lastMessage: 'Ay pajarito',
        avatarImage: 'assets/images/avatars/daniel.jpg',
        avatarLetter: 'D',
        avatarColor: const Color(0xFFD7CCC8),
        unreadCount: 0,
      ),
      ChatItem(
        name: 'Jonathan Rosales',
        lastMessage: 'Tú: Como están muchachos',
        avatarImage: 'assets/images/avatars/jonathan.png',
        avatarLetter: 'J',
        avatarColor: const Color(0xFF90CAF9),
        unreadCount: 0,
      ),
      ChatItem(
        name: 'Chistopher Enrique',
        lastMessage: 'Tú: Y si vamos a chambear o no? Xd',
        avatarImage: 'assets/images/avatars/christopher.jpg',
        avatarLetter: 'C',
        avatarColor: const Color(0xFFA5D6A7),
        unreadCount: 0,
      ),
      ChatItem(
        name: 'Carlos Emanuel',
        lastMessage: 'Los Extraño :(',
        avatarImage: 'assets/images/avatars/charlie.png',
        avatarLetter: 'C',
        avatarColor: const Color(0xFFCE93D8),
        unreadCount: 0,
      ),
      ChatItem(
        name: 'Totopia',
        lastMessage: 'Irving Zelaya: KevinG mi padre🔥',
        avatarIcon: Icons.computer,
        avatarColor: Colors.black87,
        unreadCount: 1,
      ),
      ChatItem(
        name: 'Dulce Nube - Institucional',
        lastMessage: 'Buen día, equipo. Hoy necesitamos enfocarnos en tener la vitrina llena...',
        avatarImage: 'assets/images/avatars/dulceN.png',
        avatarIcon: Icons.cake,
        avatarColor: const Color(0xFFFFCC80),
        unreadCount: 1,
      ),
    ];
  }

  // Método para obtener solo chats de GRUPOS
  List<ChatItem> _getGroupChats() {
    return [
      ChatItem(
        name: 'Totopia',
        lastMessage: 'Irving Zelaya: KevinG mi padre🔥',
        avatarIcon: Icons.computer,
        avatarColor: Colors.black87,
        unreadCount: 1,
      ),
    ];
  }

  // Método para obtener solo chats de INSTITUCIONES
  List<ChatItem> _getInstitutionChats() {
    return [
      ChatItem(
        name: 'Dulce Nube - Institucional',
        lastMessage: 'Buen día, equipo. Hoy necesitamos enfocarnos en tener la vitrina llena...',
        avatarImage: 'assets/images/avatars/dulceN.png',
        avatarIcon: Icons.cake,
        avatarColor: const Color(0xFFFFCC80),
        unreadCount: 1,
      ),
    ];
  }
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String avatarLetter;
  final String? avatarImage;
  final IconData? avatarIcon;
  final Color avatarColor;
  final int unreadCount;

  ChatItem({
    required this.name,
    required this.lastMessage,
    this.avatarLetter = '?',
    this.avatarImage,
    this.avatarIcon,
    this.avatarColor = Colors.grey,
    this.unreadCount = 0,
  });
}