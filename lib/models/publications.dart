import 'dart:typed_data';
import 'dart:convert';

class Publicacion {
  final int idPublicacion;
  final String titulo;
  final String contenido;
  final String estado;
  final DateTime fechaPublicacion;
  final Uint8List? archivoAdjunto;

  Publicacion({
    required this.idPublicacion,
    required this.titulo,
    required this.contenido,
    required this.estado,
    required this.fechaPublicacion,
    this.archivoAdjunto,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    Publicacion.debugArchivoFormat(json['archivoAdjunto']);
    return Publicacion(
      idPublicacion: int.parse(json['idPublicacion'].toString()),
      titulo: json['titulo'] ?? '',
      contenido: json['contenido'] ?? '',
      estado: json['estado'] ?? '',
      fechaPublicacion: DateTime.parse(json['fechaPublicacion']),
      archivoAdjunto: _parseArchivoAdjunto(json['archivoAdjunto']),
    );
  }

  // Método estático para manejar diferentes formatos de archivo
  static Uint8List? _parseArchivoAdjunto(dynamic archivoData) {
    if (archivoData == null) return null;

    try {
      // Caso 1: String base64 directo
      if (archivoData is String) {
        // Remover prefijo de data URL si existe (data:image/png;base64,...)
        String base64String = archivoData;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }
        return base64Decode(base64String);
      }

      // Caso 2: Objeto con propiedad 'data' (Buffer de Node.js)
      if (archivoData is Map<String, dynamic> && archivoData.containsKey('data')) {
        final data = archivoData['data'];
        if (data is List) {
          return Uint8List.fromList(List<int>.from(data));
        }
        if (data is String) {
          return base64Decode(data);
        }
      }

      // Caso 3: Lista directa de bytes
      if (archivoData is List) {
        return Uint8List.fromList(List<int>.from(archivoData));
      }

      // Caso 4: Objeto con propiedad 'type' y 'data' (formato completo de Buffer)
      if (archivoData is Map<String, dynamic> &&
          archivoData['type'] == 'Buffer' &&
          archivoData.containsKey('data')) {
        final data = archivoData['data'];
        if (data is List) {
          return Uint8List.fromList(List<int>.from(data));
        }
      }

      print('Formato de archivo no reconocido: ${archivoData.runtimeType}');
      print('Contenido: $archivoData');
      return null;

    } catch (e) {
      print('Error parseando archivo adjunto: $e');
      print('Datos recibidos: $archivoData');
      return null;
    }
  }

  // Método para debugging - puedes llamarlo temporalmente
  static void debugArchivoFormat(dynamic archivoData) {
    print('=== DEBUG ARCHIVO ADJUNTO ===');
    print('Tipo: ${archivoData?.runtimeType}');
    print('Es null: ${archivoData == null}');

    if (archivoData != null) {
      if (archivoData is Map) {
        print('Keys del Map: ${archivoData.keys.toList()}');
        archivoData.forEach((key, value) {
          print('$key: ${value?.runtimeType} - ${value.toString().length > 50 ? value.toString().substring(0, 50) + '...' : value}');
        });
      } else if (archivoData is String) {
        print('String length: ${archivoData.length}');
        print('Contiene "data:": ${archivoData.contains("data:")}');
        print('Contiene base64: ${archivoData.contains("base64")}');
      } else if (archivoData is List) {
        print('List length: ${archivoData.length}');
        if (archivoData.isNotEmpty) {
          print('Primer elemento: ${archivoData.first} (${archivoData.first.runtimeType})');
        }
      }
    }
    print('=============================');
  }
}