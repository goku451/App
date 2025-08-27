import 'package:flutter/material.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  // Estados para los toggles de privacidad
  bool _cuentaPrivada = false;
  bool _estadoActividad = true;
  bool _guardarDatosSesion = true;

  // Estados para los toggles de notificaciones
  bool _meGusta = true;
  bool _comentarios = true;
  bool _nuevosSeguidores = true;
  bool _mencionesEtiquetas = true;
  bool _visualizacionesPerfil = true;
  bool _publicacionesCompartidas = true;
  bool _publicacionesInteractuaste = true;

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
          'Seguridad y privacidad',
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
              // Sección Privacidad
              _buildSectionTitle('Privacidad'),
              const SizedBox(height: 12),

              // Visibilidad
              _buildSubSectionTitle('Visibilidad'),
              const SizedBox(height: 8),

              _buildPrivacyCard([
                _buildToggleItem(
                  title: 'Cuenta privada',
                  description: 'Los usuarios no podrán ver tu información personal, a menos que seas el administrador de la plataforma.',
                  value: _cuentaPrivada,
                  onChanged: (value) {
                    setState(() {
                      _cuentaPrivada = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildToggleItem(
                  title: 'Estado de actividad',
                  description: 'Tú y los usuarios verán su estado de actividad. Debes tener la opción activada.',
                  value: _estadoActividad,
                  onChanged: (value) {
                    setState(() {
                      _estadoActividad = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 32),

              // Sección Seguridad
              _buildSectionTitle('Seguridad'),
              const SizedBox(height: 12),

              _buildPrivacyCard([
                _buildNavigationItem(
                  title: 'Alertas de seguridad',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _buildNavigationItem(
                  title: 'Verificación de seguridad',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _buildNavigationItemWithStatus(
                  title: 'Permitir activar chats mediante mi código',
                  status: 'Activado',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _buildToggleItem(
                  title: 'Guardar los datos de inicio de sesión',
                  description: 'Inicia sesión en smartsys en este dispositivo sin necesidad de ingresar tus datos.',
                  value: _guardarDatosSesion,
                  onChanged: (value) {
                    setState(() {
                      _guardarDatosSesion = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildNavigationItem(
                  title: 'Bloquear usuarios',
                  onTap: () {},
                ),
              ]),


              const SizedBox(height: 32),

              const SizedBox(height: 16),
              _buildSubSectionTitle('Interacciones'),
              const SizedBox(height: 8),

              _buildPrivacyCard([
                _buildToggleItem(
                  title: 'Notificaciones',
                  value: _meGusta,
                  onChanged: (value) {
                    setState(() {
                      _meGusta = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildToggleItem(
                  title: 'Comentarios',
                  value: _comentarios,
                  onChanged: (value) {
                    setState(() {
                      _comentarios = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildToggleItem(
                  title: 'Chat habilitado',
                  value: _nuevosSeguidores,
                  onChanged: (value) {
                    setState(() {
                      _nuevosSeguidores = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildToggleItem(
                  title: 'Permitir descarga de archivos de publicaciones',
                  value: _publicacionesCompartidas,
                  onChanged: (value) {
                    setState(() {
                      _publicacionesCompartidas = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[isDarkMode ? 400 : 600],
      ),
    );
  }

  Widget _buildPrivacyCard(List<Widget> children) {
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

  Widget _buildToggleItemWithDescription({
    required String title,
    required String description,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[isDarkMode ? 400 : 600],
                        height: 1.4,
                      ),
                    ),
                  ],
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
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[isDarkMode ? 400 : 600],
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavigationItemWithStatus({
    required String title,
    required String status,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[isDarkMode ? 400 : 600],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[isDarkMode ? 400 : 600],
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavigationItemWithDescription({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[isDarkMode ? 400 : 600],
          ),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[isDarkMode ? 400 : 600],
      ),
      onTap: onTap,
    );
  }
}