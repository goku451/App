import 'dart:convert';
import 'dart:typed_data';

class User {
  final int idUsuario;
  final String nombre;
  final String apellido;
  final String correoElectronico;
  final String codigoUnico;
  final String? telefono;
  final String tipoUsuario;
  final String estadoCuenta;
  final DateTime? fechaCreacion;
  final String? biografia;

  /// Foto en Base64 (para guardar en SharedPreferences o enviar a la API)
  final String? fotoPerfilBase64;

  /// Bytes de la foto (para usar con Image.memory)
  final Uint8List? fotoBytes;

  User({
    required this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.codigoUnico,
    this.telefono,
    required this.tipoUsuario,
    required this.estadoCuenta,
    this.fechaCreacion,
    this.biografia,
    this.fotoPerfilBase64,
    this.fotoBytes,
  });

  /// Crear usuario desde JSON (respuesta de la API)
  factory User.fromJson(Map<String, dynamic> json) {
    Uint8List? bytes;
    String? base64Str;

    final foto = json['foto_perfil'];
    if (foto != null) {
      if (foto is String && foto.isNotEmpty) {
        try {
          bytes = base64Decode(foto);
          base64Str = foto;
        } catch (e) {
          print('❌ Error decodificando base64: $e');
        }
      } else if (foto is Map && foto['data'] != null) {
        try {
          List<dynamic> dataList = foto['data'];
          bytes = Uint8List.fromList(dataList.map((e) => e as int).toList());
          base64Str = base64Encode(bytes);
        } catch (e) {
          print('❌ Error convirtiendo Buffer a Uint8List: $e');
        }
      }
    }

    return User(
      idUsuario: _parseId(json['idUsuario']),
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correoElectronico: json['correoElectronico'] ?? '',
      codigoUnico: json['codigoUnico'] ?? '',
      telefono: json['telefono'],
      tipoUsuario: json['tipoUsuario'] ?? 'Usuario',
      estadoCuenta: json['estadoCuenta'] ?? 'Activo',
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.tryParse(json['fechaCreacion'].toString())
          : null,
      biografia: json['biografia'],
      fotoPerfilBase64: base64Str,
      fotoBytes: bytes,
    );
  }

  /// Convertir usuario a JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'apellido': apellido,
      'correoElectronico': correoElectronico,
      'telefono': telefono,
      'tipoUsuario': tipoUsuario,
      'estadoCuenta': estadoCuenta,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
      'biografia': biografia,
      'foto_perfil': fotoPerfilBase64,
    };
  }

  /// Obtener nombre completo
  String get nombreCompleto => '$nombre $apellido';

  /// Copiar usuario con nuevos valores
  User copyWith({
    int? idUsuario,
    String? nombre,
    String? apellido,
    String? correoElectronico,
    String? telefono,
    String? tipoUsuario,
    String? estadoCuenta,
    DateTime? fechaCreacion,
    String? biografia,
    String? fotoPerfilBase64,
    Uint8List? fotoBytes,
  }) {
    return User(
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      codigoUnico: codigoUnico ?? this.codigoUnico,
      telefono: telefono ?? this.telefono,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      estadoCuenta: estadoCuenta ?? this.estadoCuenta,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      biografia: biografia ?? this.biografia,
      fotoPerfilBase64: fotoPerfilBase64 ?? this.fotoPerfilBase64,
      fotoBytes: fotoBytes ?? this.fotoBytes,
    );
  }

  @override
  String toString() {
    return 'User{idUsuario: $idUsuario, nombreCompleto: $nombreCompleto, email: $correoElectronico, fotoBase64: ${fotoPerfilBase64 != null ? "Sí" : "No"}}';
  }

  /// Helper para convertir ID a int
  static int _parseId(dynamic id) {
    if (id == null) return 0;
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }
}
