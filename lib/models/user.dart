// lib/models/user.dart
class User {
  final int idUsuario;
  final String nombre;
  final String apellido;
  final String correoElectronico;
  final String? telefono;
  final String? genero;
  final String tipoUsuario;
  final String estadoCuenta;
  final DateTime? fechaCreacion;
  final String? biografia;
  final String? fotoPerfil; // ← NUEVO: Campo para foto de perfil

  User({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    this.telefono,
    this.genero,
    required this.tipoUsuario,
    required this.estadoCuenta,
    this.fechaCreacion,
    this.biografia,
    this.fotoPerfil, // ← NUEVO
  });

  // Crear usuario desde JSON (respuesta de la API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: _parseId(json['idUsuario']),
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correoElectronico: json['correoElectronico'] ?? '',
      telefono: json['telefono'],
      genero: json['genero'],
      tipoUsuario: json['tipoUsuario'] ?? 'Usuario',
      estadoCuenta: json['estadoCuenta'] ?? 'Activo',
      fechaCreacion: json['fechaCreacion'] != null 
          ? DateTime.tryParse(json['fechaCreacion'].toString()) 
          : null,
      biografia: json['biografia'],
      fotoPerfil: json['foto_perfil'], // ← NUEVO: Mapear foto_perfil
    );
  }

  // Método helper para convertir ID de cualquier tipo a int
  static int _parseId(dynamic id) {
    if (id == null) return 0;
    if (id is int) return id;
    if (id is String) {
      return int.tryParse(id) ?? 0;
    }
    return 0;
  }

  // Convertir usuario a JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'apellido': apellido,
      'correoElectronico': correoElectronico,
      'telefono': telefono,
      'genero': genero,
      'tipoUsuario': tipoUsuario,
      'estadoCuenta': estadoCuenta,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
      'biografia': biografia,
      'foto_perfil': fotoPerfil, // ← NUEVO
    };
  }

  // Método para obtener nombre completo
  String get nombreCompleto => '$nombre $apellido';

  // Método para obtener URL completa de foto de perfil
  String? getPhotoUrl(String baseUrl) {
    if (fotoPerfil == null || fotoPerfil!.isEmpty) return null;
    if (fotoPerfil!.startsWith('http')) return fotoPerfil; // URL completa
    return '$baseUrl/$fotoPerfil'; // URL relativa
  }

  // Copiar usuario con nuevos valores
  User copyWith({
    int? idUsuario,
    String? nombre,
    String? apellido,
    String? correoElectronico,
    String? telefono,
    String? genero,
    String? tipoUsuario,
    String? estadoCuenta,
    DateTime? fechaCreacion,
    String? biografia,
    String? fotoPerfil, // ← NUEVO
  }) {
    return User(
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      telefono: telefono ?? this.telefono,
      genero: genero ?? this.genero,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      estadoCuenta: estadoCuenta ?? this.estadoCuenta,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      biografia: biografia ?? this.biografia,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil, // ← NUEVO
    );
  }

  @override
  String toString() {
    return 'User{idUsuario: $idUsuario, nombreCompleto: $nombreCompleto, email: $correoElectronico, foto: $fotoPerfil}';
  }
}