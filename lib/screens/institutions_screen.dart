import 'package:flutter/material.dart';

class InstitutionsScreen extends StatefulWidget {
  const InstitutionsScreen({super.key});

  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  int _selectedIndex = 2; // Institutions tab selected
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  // Sample institutions data
  List<Institution> institutions = [
    Institution(
      id: "1",
      name: "North West Africa",
      description: "Comunidad africana del noroeste",
      backgroundImage: "assets/images/institutions/africa.jpg",
      logoImage: "assets/images/institutions/africa_logo.png",
      color: Colors.orange,
      memberCount: 1250,
      postCount: 45,
      eventCount: 8,
    ),
    Institution(
      id: "2",
      name: "A Saint's Church",
      description: "Iglesia de los santos",
      backgroundImage: "assets/images/institutions/church.jpg",
      logoImage: "assets/images/institutions/church_logo.png",
      color: Colors.blue,
      memberCount: 890,
      postCount: 32,
      eventCount: 12,
    ),
    Institution(
      id: "3",
      name: "Cybersafety",
      description: "Seguridad cibernética y educación",
      backgroundImage: "assets/images/institutions/cyber.jpg",
      logoImage: "assets/images/institutions/cyber_logo.png",
      color: Colors.green,
      memberCount: 2100,
      postCount: 78,
      eventCount: 15,
    ),
    Institution(
      id: "4",
      name: "Redacción",
      description: "Periodismo y comunicación",
      backgroundImage: "assets/images/institutions/news.jpg",
      logoImage: "assets/images/institutions/news_logo.png",
      color: Colors.red,
      memberCount: 567,
      postCount: 156,
      eventCount: 6,
    ),
    Institution(
      id: "5",
      name: "El Camino en vivo",
      description: "Transmisiones en directo",
      backgroundImage: "assets/images/institutions/live.jpg",
      logoImage: "assets/images/institutions/live_logo.png",
      color: Colors.purple,
      memberCount: 3400,
      postCount: 89,
      eventCount: 20,
    ),
    Institution(
      id: "6",
      name: "TCEL",
      description: "Tecnología y educación",
      backgroundImage: "assets/images/institutions/tech.jpg",
      logoImage: "assets/images/institutions/tech_logo.png",
      color: Colors.grey,
      memberCount: 1800,
      postCount: 234,
      eventCount: 18,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and notification bell
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo section
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.star_outline,
                            size: 24,
                            color: Color(0xFF41277A),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SmartSys',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
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

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                          hintText: 'Buscar instituciones',
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

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recents Groups',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Institutions list
            Expanded(
              child: _buildInstitutionsList(),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddInstitutionDialog();
        },
        backgroundColor: const Color(0xFF41277A),
        child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildInstitutionsList() {
    List<Institution> filteredInstitutions = institutions;

    // Filter institutions based on search query
    if (_searchQuery.isNotEmpty) {
      filteredInstitutions = institutions.where((institution) {
        return institution.name.toLowerCase().contains(_searchQuery) ||
            institution.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (filteredInstitutions.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
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
                'No se encontraron instituciones',
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
      itemCount: filteredInstitutions.length,
      itemBuilder: (context, index) {
        final institution = filteredInstitutions[index];
        return _buildInstitutionCard(institution);
      },
    );
  }

  Widget _buildInstitutionCard(Institution institution) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    institution.color.withOpacity(0.8),
                    institution.color.withOpacity(0.6),
                    institution.color.withOpacity(0.9),
                  ],
                ),
              ),
            ),
            // Pattern overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
            // Content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _navigateToInstitutionDetail(institution);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Institution logo
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: institution.logoImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  institution.logoImage!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.business,
                                      color: institution.color,
                                      size: 25,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.business,
                                color: institution.color,
                                size: 25,
                              ),
                      ),
                      const SizedBox(width: 16),
                      // Institution info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              institution.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              institution.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Stats row
                            Row(
                              children: [
                                _buildStatChip(
                                  Icons.people,
                                  "${institution.memberCount}",
                                ),
                                const SizedBox(width: 8),
                                _buildStatChip(
                                  Icons.article,
                                  "${institution.postCount}",
                                ),
                                const SizedBox(width: 8),
                                _buildStatChip(
                                  Icons.event,
                                  "${institution.eventCount}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Arrow icon
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToInstitutionDetail(Institution institution) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstitutionDetailScreen(institution: institution),
      ),
    );
  }

  void _showAddInstitutionDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Agregar Institución"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la institución",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Text("Color de la institución:"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                    Colors.orange,
                    Colors.purple,
                    Colors.teal,
                  ].map((color) => GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    descriptionController.text.isNotEmpty) {
                  setState(() {
                    institutions.add(
                      Institution(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        description: descriptionController.text,
                        color: selectedColor,
                        memberCount: 1,
                        postCount: 0,
                        eventCount: 0,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Institución agregada exitosamente"),
                      backgroundColor: Color(0xFF41277A),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF41277A),
                foregroundColor: Colors.white,
              ),
              child: Text("Agregar"),
            ),
          ],
        ),
      ),
    );
  }
}

// Institution model class
class Institution {
  final String id;
  final String name;
  final String description;
  final String? backgroundImage;
  final String? logoImage;
  final Color color;
  final int memberCount;
  final int postCount;
  final int eventCount;

  Institution({
    required this.id,
    required this.name,
    required this.description,
    this.backgroundImage,
    this.logoImage,
    required this.color,
    required this.memberCount,
    required this.postCount,
    required this.eventCount,
  });
}

// Institution Detail Screen
class InstitutionDetailScreen extends StatelessWidget {
  final Institution institution;

  const InstitutionDetailScreen({super.key, required this.institution});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with background
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: institution.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                institution.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      institution.color.withOpacity(0.8),
                      institution.color,
                    ],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(
                      Icons.business,
                      color: institution.color,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Miembros",
                          institution.memberCount.toString(),
                          Icons.people,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          "Publicaciones",
                          institution.postCount.toString(),
                          Icons.article,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          "Eventos",
                          institution.eventCount.toString(),
                          Icons.event,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    "Descripción",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    institution.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick actions
                  Text(
                    "Acciones rápidas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    "Ver publicaciones",
                    Icons.article,
                    () {
                      // Navigate to posts
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    "Ver eventos",
                    Icons.event,
                    () {
                      // Navigate to events
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    "Ver anuncios",
                    Icons.campaign,
                    () {
                      // Navigate to announcements
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF41277A)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}