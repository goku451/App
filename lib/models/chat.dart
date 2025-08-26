import 'dart:convert';
import 'dart:typed_data';


class Mensaje {
  final int idChat;
  final int idMensaje;
  final int idUsuarioEmisor;
  final int idUsuarioReceptor;
  final Uint8List? fotoPerfil;
  final String? apellidoUsuarioReceptor;
  final String mensaje;
  final String fecha;

  Mensaje({
    this.apellidoUsuarioReceptor,
    this.fotoPerfil,
    required this.idChat,
    required this.idMensaje,
    required this.idUsuarioEmisor,
    required this.idUsuarioReceptor,
    required this.mensaje,
    required this.fecha,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idChat: json['idChat'] is int ? json['idChat'] : int.parse(json['idChat'].toString()),
      idMensaje: json['idMensaje'] is int ? json['idMensaje'] : int.parse(json['idMensaje'].toString()),
      idUsuarioEmisor: json['idUsuarioEmisor'] is int ? json['idUsuarioEmisor'] : int.parse(json['idUsuarioEmisor'].toString()),
      idUsuarioReceptor: json['idUsuarioReceptor'] is int ? json['idUsuarioReceptor'] : int.parse(json['idUsuarioReceptor'].toString()),
      fotoPerfil: json['fotoPerfil'] != null ? base64Decode(json['fotoPerfil']) : null,
      apellidoUsuarioReceptor: json['apellidoUsuarioReceptor'],
      mensaje: json['mensaje'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}

class ChatData {
  final int idChat;
  final int idUsuarioEmisor;
  final int idUsuarioReceptor;
  final List<Mensaje> mensajes;

  ChatData({
    required this.idChat,
    required this.idUsuarioEmisor,
    required this.idUsuarioReceptor,
    required this.mensajes,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    var mensajesJson = json['mensajes'] as List<dynamic>? ?? [];
    return ChatData(
      idChat: json['idChat'] is int
          ? json['idChat']
          : int.parse(json['idChat'].toString()),
      idUsuarioEmisor: json['idUsuarioEmisor'] is int
          ? json['idUsuarioEmisor']
          : int.parse(json['idUsuarioEmisor'].toString()),
      idUsuarioReceptor: json['idUsuarioReceptor'] is int
          ? json['idUsuarioReceptor']
          : int.parse(json['idUsuarioReceptor'].toString()),
      mensajes: mensajesJson.map((m) => Mensaje.fromJson(m)).toList(),
    );
  }
}
