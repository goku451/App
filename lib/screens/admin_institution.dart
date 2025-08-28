import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_application_1/generated/l10n.dart';

class AdminInstitutionScreen extends StatefulWidget {
  const AdminInstitutionScreen({super.key});

  @override
  State<AdminInstitutionScreen> createState() => _AdminInstitutionScreenState();
}

class _AdminInstitutionScreenState extends State<AdminInstitutionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _invitationCodeController = TextEditingController();

  // Estados para los toggles
  bool _isPrivate = false;
  bool _isActive = true;
  String _platformStatus = 'Activo';

  // Estados para notificaciones y opciones
  bool _allowNotifications = true;
  bool _allowComments = true;
  bool _allowChat = true;
  bool _allowFileDownload = true;
  bool _showActivityStatus = true;
  bool _saveSessionData = true;

  // Mock data para el historial de contenido
  final List<Map<String, dynamic>> _contentHistory = [
    {
      'title': 'Prueba',
      'type': 'P',
      'date': '27-08-2025',
      'file': 'documento.pdf',
    },
    {
      'title': 'Presentación de fnaf',
      'type': 'T',
      'date': '7-08-2025',
      'file': 'pitch_deck.pptx',
    },
    {
      'title': 'Video de la historia de fnaf',
      'type': 'P',
      'date': '13-07-2025',
      'file': 'marketing_tutorial.mp4',
    },
    {
      'title': 'Tales from the pizzaplex',
      'type': 'A',
      'date': '27-8-1987',
      'file': 'FULL_fnaf.docx',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Inicializar con datos de ejemplo
    _nameController.text = 'Five Nights At Freddys';
    _descriptionController.text = 'Fan group de fnaf.';
    _invitationCodeController.text = 'BT1987';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _invitationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          'Editar Plataforma',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _savePlatform,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: const Color(0xFF41277A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF41277A),
          labelColor: const Color(0xFF41277A),
          unselectedLabelColor: Colors.grey[isDarkMode ? 400 : 600],
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Detalles'),
            Tab(text: 'Opciones'),
            Tab(text: 'Contenido'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildOptionsTab(),
          _buildContentTab(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner con icono superpuesto
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF41277A), Color(0xFF6B46C1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  top: 16,
                  child: GestureDetector(
                    onTap: _editBannerImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Editar imagen de banner',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Icono de plataforma superpuesto
          Transform.translate(
            offset: const Offset(0, -30),
            child: Center(
              child: GestureDetector(
                onTap: _editIconImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 65, 65, 65)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.account_balance,
                          size: 40,
                          color: const Color(0xFF41277A),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF41277A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Formulario de detalles
          _buildFormCard([
            _buildTextField(
              controller: _nameController,
              label: 'Nombre de la plataforma (obligatorio)',
              hint: 'Ingresa el nombre de tu plataforma',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Descripción',
              hint: 'Describe tu plataforma',
              maxLines: 4,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOptionsTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección Privacidad
          _buildSectionTitle('Privacidad'),
          const SizedBox(height: 12),

          _buildFormCard([
            _buildToggleItem(
              title: 'Plataforma privada',
              description: 'Solo los usuarios con código de invitación podrán unirse.',
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
            if (_isPrivate) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildTextField(
                  controller: _invitationCodeController,
                  label: 'Código de invitación',
                  hint: 'Código para unirse a la plataforma',
                ),
              ),
            ],
          ]),

          const SizedBox(height: 24),

          // Sección Estado
          _buildSectionTitle('Estado de la plataforma'),
          const SizedBox(height: 12),

          _buildFormCard([
            _buildDropdownItem(),
          ]),

          const SizedBox(height: 24),

          // Sección Interacciones
          _buildSectionTitle('Interacciones'),
          const SizedBox(height: 12),

          _buildFormCard([
            _buildToggleItem(
              title: 'Permitir notificaciones',
              value: _allowNotifications,
              onChanged: (value) {
                setState(() {
                  _allowNotifications = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildToggleItem(
              title: 'Permitir comentarios',
              value: _allowComments,
              onChanged: (value) {
                setState(() {
                  _allowComments = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildToggleItem(
              title: 'Chat habilitado',
              value: _allowChat,
              onChanged: (value) {
                setState(() {
                  _allowChat = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildToggleItem(
              title: 'Permitir descarga de archivos',
              description: 'Los usuarios podrán descargar archivos de las publicaciones.',
              value: _allowFileDownload,
              onChanged: (value) {
                setState(() {
                  _allowFileDownload = value;
                });
              },
            ),
          ]),

          const SizedBox(height: 24),

          // Sección Configuración adicional
          _buildSectionTitle('Configuración adicional'),
          const SizedBox(height: 12),

          _buildFormCard([
            _buildToggleItem(
              title: 'Mostrar estado de actividad',
              description: 'Los miembros verán cuando otros están activos.',
              value: _showActivityStatus,
              onChanged: (value) {
                setState(() {
                  _showActivityStatus = value;
                });
              },
            ),
          ]),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Historial de contenido'),
          const SizedBox(height: 12),

          // Tabla de contenido
          _buildFormCard([
            // Header de la tabla
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Título',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Tipo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Fecha',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Acciones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido de la tabla
            ..._contentHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final content = entry.value;
              return Column(
                children: [
                  if (index > 0) const Divider(height: 1),
                  _buildContentRow(content),
                ],
              );
            }).toList(),
          ]),

          if (_contentHistory.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 64,
                    color: Colors.grey[isDarkMode ? 500 : 400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin contenido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[isDarkMode ? 400 : 600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aún no hay publicaciones en esta plataforma.',
                    style: TextStyle(
                      color: Colors.grey[isDarkMode ? 500 : 500],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContentRow(Map<String, dynamic> content) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  content['file'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[isDarkMode ? 400 : 600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(content['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                content['type'],
                style: TextStyle(
                  fontSize: 12,
                  color: _getTypeColor(content['type']),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              content['date'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[isDarkMode ? 400 : 600],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.visibility_outlined,
                  onTap: () => _viewContent(content),
                ),
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  onTap: () => _editContent(content),
                ),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  onTap: () => _deleteContent(content),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (color ?? Colors.grey[isDarkMode ? 600 : 400])?.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color ?? Colors.grey[isDarkMode ? 400 : 600],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'p':
        return Colors.blue;
      case 't':
        return Colors.orange;
      case 'a':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[isDarkMode ? 600 : 300]!,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[isDarkMode ? 400 : 400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String title,
    String? description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF00D4AA),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[isDarkMode ? 600 : 300],
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[isDarkMode ? 400 : 600],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdownItem() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[isDarkMode ? 600 : 300]!,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: _platformStatus,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              dropdownColor: isDarkMode
                  ? const Color.fromARGB(255, 65, 65, 65)
                  : Colors.white,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              items: ['Activo', 'Inactivo', 'Suspendido'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(
                        value == 'Activo'
                            ? Icons.check_circle
                            : value == 'Inactivo'
                            ? Icons.pause_circle
                            : Icons.block,
                        size: 16,
                        color: value == 'Activo'
                            ? Colors.green
                            : value == 'Inactivo'
                            ? Colors.orange
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _platformStatus = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editBannerImage() {
    // editar imagen de banner
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Editar imagen de banner')),
    );
  }

  void _editIconImage() {
    // editar icono
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Editar icono de plataforma')),
    );
  }

  void _savePlatform() {
    // guardar cambios
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados exitosamente')),
    );
  }

  void _viewContent(Map<String, dynamic> content) {
    // ver contenido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ver: ${content['title']}')),
    );
  }

  void _editContent(Map<String, dynamic> content) {
    // Implementar lógica para editar contenido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar: ${content['title']}')),
    );
  }

  void _deleteContent(Map<String, dynamic> content) {
    // Mostrar confirmación antes de eliminar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 65, 65, 65)
              : Colors.white,
          title: Text(
            'Eliminar contenido',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${content['title']}"?',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[isDarkMode ? 400 : 600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _contentHistory.remove(content);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${content['title']} eliminado')),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}