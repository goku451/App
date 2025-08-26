import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/publications.dart';
import 'package:flutter_application_1/generated/l10n.dart';

class PublicationsScreen extends StatefulWidget {
  final int? idPlataforma; // ahora opcional
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

class _PublicationsScreenState extends State<PublicationsScreen> {
  late int _idPlataforma;
  bool _isLoading = true;
  List<Publicacion> _publicaciones = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Espera a que el contexto esté disponible para obtener argumentos si no se pasó el ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        _idPlataforma = widget.idPlataforma ?? args?['idPlataforma'] ?? 0;
      });
      _loadPublicaciones();
    });
  }

  Future<void> _loadPublicaciones() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.getPublicaciones(
        idPlataforma: _idPlataforma,
      );

      if (response.success && response.data != null) {
        setState(() {
          _publicaciones = response.data!;
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
        _errorMessage = "Error al cargar publicaciones: $e";
        _isLoading = false;
      });
    }
  }

  void _showPublicationDetails(Publicacion pub) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? const Color.fromARGB(255, 65, 65, 65) : Colors.white,
          title: Text(
            pub.titulo,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pub.contenido,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${S.of(context).Date}: ${pub.fechaPublicacion.toString().split('T')[0]}",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${S.of(context).State}: ${pub.estado}",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                if (pub.archivoAdjunto != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.memory(
                      pub.archivoAdjunto!,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).Close,
                style: TextStyle(color: Colors.grey[isDarkMode ? 400 : 600]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPublicationCard(Publicacion pub) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color estadoColor = pub.estado == 'Activo' ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: () => _showPublicationDetails(pub),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDarkMode ? const Color.fromARGB(255, 65, 65, 65) : Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pub.titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pub.contenido,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(pub.estado, estadoColor),
                const SizedBox(width: 8),
                Text(
                  pub.fechaPublicacion.toString().split('T')[0],
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          S.of(context).Publications,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPublicaciones,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey[isDarkMode ? 500 : 400],
                    ),
                  ),
                if (!_isLoading && _errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.red[900]!.withOpacity(0.3)
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode ? Colors.red[400]! : Colors.red[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: isDarkMode ? Colors.red[400] : Colors.red[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: isDarkMode ? Colors.red[400] : Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!_isLoading && _publicaciones.isEmpty && _errorMessage == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: Colors.grey[isDarkMode ? 500 : 400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).NoPublications,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[isDarkMode ? 400 : 600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context).NoPublicationsMessage,
                            style: TextStyle(
                              color: Colors.grey[isDarkMode ? 500 : 500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!_isLoading && _publicaciones.isNotEmpty)
                  ..._publicaciones.map((pub) => _buildPublicationCard(pub)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
