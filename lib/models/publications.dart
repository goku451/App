import 'dart:typed_data';

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
    return Publicacion(
      idPublicacion: int.parse(json['idPublicacion'].toString()),
      titulo: json['titulo'] ?? '',
      contenido: json['contenido'] ?? '',
      estado: json['estado'] ?? '',
      fechaPublicacion: DateTime.parse(json['fechaPublicacion']),
      archivoAdjunto: json['archivoAdjunto'] != null
          ? Uint8List.fromList(List<int>.from(json['archivoAdjunto']['data'] ?? []))
          : null,
    );
  }
}
