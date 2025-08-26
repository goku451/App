class Publicacion {
  final int idPublicacion;
  final String titulo;
  final String contenido;
  final String estado;
  final DateTime fechaCreacion;

  Publicacion({
    required this.idPublicacion,
    required this.titulo,
    required this.contenido,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      idPublicacion: json['idPublicacion'],
      titulo: json['titulo'],
      contenido: json['contenido'],
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }
}
