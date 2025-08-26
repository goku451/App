import 'dart:convert';
import 'dart:typed_data';

class Plataforma {
  final int idPlataforma;
  final String nombrePlataforma;
  final String? descripcionPlataforma;
  final String privacidadPlataforma;
  final int capacidadMiembros;
  final String estadoPlataforma;
  final DateTime fechaCreacion;

  // Imágenes
  final String? iconoBase64;
  final String? fondoBase64;
  final Uint8List? iconoBytes;
  final Uint8List? fondoBytes;

  Plataforma({
    required this.idPlataforma,
    required this.nombrePlataforma,
    this.descripcionPlataforma,
    required this.privacidadPlataforma,
    required this.capacidadMiembros,
    required this.estadoPlataforma,
    required this.fechaCreacion,
    this.iconoBase64,
    this.fondoBase64,
    this.iconoBytes,
    this.fondoBytes,
  });

  factory Plataforma.fromJson(Map<String, dynamic> json) {
    // Función para convertir bytes a base64 string
    String? parseBase64(dynamic value) {
      try {
        // Caso 1: Buffer { data: [137, 80, 78, 71...] }
        if (value is Map && value['data'] is List) {
          final bytes = Uint8List.fromList(List<int>.from(value['data']));
          return base64Encode(bytes);
        }

        // Caso 2: Ya es un string base64
        if (value is String && value.isNotEmpty) {
          return value;
        }
      } catch (_) {}
      return null;
    }

    // Función para convertir a bytes
    Uint8List? parseBytes(dynamic value) {
      try {
        // Caso 1: Buffer { data: [137, 80, 78, 71...] }
        if (value is Map && value['data'] is List) {
          return Uint8List.fromList(List<int>.from(value['data']));
        }

        // Caso 2: String en base64
        if (value is String && value.isNotEmpty) {
          return base64Decode(value);
        }
      } catch (_) {}
      return null;
    }

    return Plataforma(
      idPlataforma: int.tryParse(
        json['idPlataforma']?.toString() ??
        json['id']?.toString() ??
        ''
      ) ?? 0,
      nombrePlataforma: json['nombrePlataforma'] ?? '',
      descripcionPlataforma: json['descripcionPlataforma'],
      privacidadPlataforma: json['privacidadPlataforma'] ?? 'Privado',
      capacidadMiembros:
          int.tryParse(
            json['capacidadMiembros_plataforma']?.toString() ?? '',
          ) ??
          100,
      estadoPlataforma: json['estadoPlataforma'] ?? 'Activo',
      fechaCreacion:
          DateTime.tryParse(json['fechaCreacion']?.toString() ?? '') ??
          DateTime.now(),

      // Usar las funciones helper para manejar ambos formatos
      iconoBase64: parseBase64(json['iconoPlataforma']),
      fondoBase64: parseBase64(json['fondoPlataforma']),
      iconoBytes: parseBytes(json['iconoPlataforma']),
      fondoBytes: parseBytes(json['fondoPlataforma']),
    );
  }
}