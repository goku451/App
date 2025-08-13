// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  // RECORDAR CAMBIAR SOLO LA IP A LA IP LOCAL DE LA COMPUTADORA
  // SI NO SABEN CUAL ES ESCRIBIR IPCONFIG EN CMD
  static const String baseUrl = 'http://192.168.1.6:3000';

  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Registrar nuevo usuario
  static Future<ApiResponse<User>> register({
    required String nombre,
    required String apellido,
    required String correoElectronico,
    required String contrasena,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/registro');

      final body = json.encode({
        'nombre': nombre,
        'apellido': apellido,
        'correoElectronico': correoElectronico,
        'contrasena': contrasena,
      });

      print('🚀 Enviando registro a: $url');
      print('📦 Datos: $body');

      final response = await http
          .post(url, headers: defaultHeaders, body: body)
          .timeout(const Duration(seconds: 10));

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de respuesta: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData['ok'] == true) {
        // Crear usuario desde la respuesta
        final user = User.fromJson(responseData['data']);

        // Guardar usuario en SharedPreferences
        await _saveUserData(user);

        print('🔍 Datos del usuario desde API: ${responseData['data']}');
        print('✅ Usuario guardado: ${user.nombreCompleto}');

        return ApiResponse.success(
          data: user,
          message: responseData['message'] ?? 'Registro exitoso',
        );
      } else {
        return ApiResponse.error(
          message: responseData['message'] ?? 'Error en el registro',
        );
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      return ApiResponse.error(
        message:
            'Error de conexión. Verifica tu internet y que la API esté funcionando.',
      );
    }
  }

  // Iniciar sesión
  static Future<ApiResponse<User>> login({
    required String correoElectronico,
    required String contrasena,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final body = json.encode({
        'correoElectronico': correoElectronico,
        'contrasena': contrasena,
      });

      print('🚀 Enviando login a: $url');
      print('📦 Datos: $body');

      final response = await http
          .post(url, headers: defaultHeaders, body: body)
          .timeout(const Duration(seconds: 10));

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de respuesta: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        // Crear usuario desde la respuesta
        final user = User.fromJson(responseData['data']);

        // Guardar usuario en SharedPreferences
        await _saveUserData(user);

        print('🔍 Datos del usuario desde API: ${responseData['data']}');
        print('✅ Usuario logueado: ${user.nombreCompleto}');

        return ApiResponse.success(
          data: user,
          message: responseData['message'] ?? 'Login exitoso',
        );
      } else {
        return ApiResponse.error(
          message: responseData['message'] ?? 'Credenciales inválidas',
        );
      }
    } catch (e) {
      print('❌ Error en login: $e');
      return ApiResponse.error(
        message:
            'Error de conexión. Verifica tu internet y que la API esté funcionando.',
      );
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data'); // También eliminar datos del usuario
  }

  // Verificar si hay token guardado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Obtener token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Guardar datos del usuario
  static Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));
  }

  // Obtener datos del usuario guardados
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');

      if (userData != null) {
        final userMap = json.decode(userData);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  // Guardar token
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Probar conexión con la API
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/test');
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      print('🔍 Test de conexión: ${response.statusCode}');
      print('📄 Respuesta: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error en test de conexión: $e');
      return false;
    }
  }

  //Actualizar perfil de usuario
  static Future<ApiResponse<User>> updateProfile({
    required int idUsuario,
    required String nombre,
    required String apellido,
    String? telefono,
    String? biografia,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/actualizarPerfil');

      final body = json.encode({
        'idUsuario': idUsuario,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'biografia': biografia,
      });

      print('🚀 Enviando actualización de perfil a: $url');
      print('📦 Datos: $body');

      final response = await http
          .post(url, headers: defaultHeaders, body: body)
          .timeout(const Duration(seconds: 10));

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de respuesta: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['success'] == true &&
          responseData['data'] != null) {
        // Crear usuario actualizado desde la respuesta
        final updatedUser = User.fromJson(responseData['data']);

        // Actualizar datos guardados localmente
        await _saveUserData(updatedUser);

        print('✅ Perfil actualizado: ${updatedUser.nombreCompleto}');

        return ApiResponse.success(
          data: updatedUser,
          message: responseData['message'] ?? 'Perfil actualizado exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: responseData['message'] ?? 'Error actualizando perfil',
        );
      }
    } catch (e) {
      print('❌ Error actualizando perfil: $e');
      return ApiResponse.error(
        message:
            'Error de conexión. Verifica tu internet y que la API esté funcionando.',
      );
    }
  }

  // Subir foto de perfil
  static Future<ApiResponse<User>> uploadProfilePhoto({
    required int idUsuario,
    required String imagePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/subirFotoPerfil');

      print('📸 Subiendo foto de perfil a: $url');
      print('📁 Ruta de imagen: $imagePath');

      // Crear multipart request
      var request = http.MultipartRequest('POST', url);

      // Agregar campos
      request.fields['idUsuario'] = idUsuario.toString();

      // Agregar archivo
      var file = await http.MultipartFile.fromPath('photo', imagePath);
      request.files.add(file);

      // Enviar request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      var response = await http.Response.fromStream(streamedResponse);

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de respuesta: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Crear usuario actualizado desde la respuesta
        final updatedUser = User.fromJson(responseData['data']);

        // Actualizar datos guardados localmente
        await _saveUserData(updatedUser);

        print('✅ Foto subida: ${updatedUser.nombreCompleto}');

        return ApiResponse.success(
          data: updatedUser,
          message: responseData['message'] ?? 'Foto actualizada exitosamente',
        );
      } else {
        return ApiResponse.error(
          message: responseData['message'] ?? 'Error subiendo foto',
        );
      }
    } catch (e) {
      print('❌ Error subiendo foto: $e');
      return ApiResponse.error(
        message:
            'Error de conexión. Verifica tu internet y que la API esté funcionando.',
      );
    }
  }
}

// Clase para manejar respuestas de la API
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;

  ApiResponse._({required this.success, this.data, required this.message});

  factory ApiResponse.success({required T data, required String message}) {
    return ApiResponse._(success: true, data: data, message: message);
  }

  factory ApiResponse.error({required String message}) {
    return ApiResponse._(success: false, data: null, message: message);
  }
}
