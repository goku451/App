// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/platform.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  // RECORDAR CAMBIAR SOLO LA IP A LA IP LOCAL DE LA COMPUTADORA
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ------------------ USUARIOS ------------------ //

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

      final response = await http.post(url, headers: defaultHeaders, body: body);

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData['ok'] == true) {
        final user = User.fromJson(responseData['data']);
        await _saveUserData(user);
        return ApiResponse.success(
            data: user, message: responseData['mensaje'] ?? 'Registro exitoso');
      } else {
        return ApiResponse.error(
            message: responseData['mensaje'] ?? 'Error en el registro');
      }
    } catch (e) {
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

  // Iniciar sesión
  static Future<ApiResponse<User>> login({
    required String correoElectronico,
    required String contrasena,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final body =
          json.encode({'correoElectronico': correoElectronico, 'contrasena': contrasena});

      final response = await http.post(url, headers: defaultHeaders, body: body);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        final user = User.fromJson(responseData['data']);
        await _saveUserData(user);
        return ApiResponse.success(
            data: user, message: responseData['mensaje'] ?? 'Login exitoso');
      } else {
        return ApiResponse.error(
            message: responseData['mensaje'] ?? 'Credenciales inválidas');
      }
    } catch (e) {
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

  // Actualizar perfil
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

      final response = await http.post(url, headers: defaultHeaders, body: body);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['success'] == true &&
          responseData['data'] != null) {
        final updatedUser = User.fromJson(responseData['data']);
        await _saveUserData(updatedUser);
        return ApiResponse.success(
            data: updatedUser,
            message: responseData['message'] ?? 'Perfil actualizado exitosamente');
      } else {
        return ApiResponse.error(
            message: responseData['message'] ?? 'Error actualizando perfil');
      }
    } catch (e) {
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

  // Actualizar perfil con foto
  static Future<ApiResponse<User>> updateProfileWithPhoto({
    required int idUsuario,
    XFile? pickedFile,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/actualizarPerfilImg');
      var request = http.MultipartRequest('POST', url);

      request.fields['idUsuario'] = idUsuario.toString();

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final multipartFile =
            http.MultipartFile.fromBytes('fotoPerfil', bytes, filename: pickedFile.name);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        final updatedUser = User.fromJson(responseData['data']);
        await _saveUserData(updatedUser);
        return ApiResponse.success(
            data: updatedUser,
            message: responseData['message'] ?? 'Perfil actualizado con éxito');
      } else {
        return ApiResponse.error(
            message: responseData['message'] ?? 'Error actualizando perfil');
      }
    } catch (e) {
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

 // ------------------ PLATAFORMAS ------------------ //

  // Buscar plataformas - RUTA CORREGIDA
  static Future<ApiResponse<List<dynamic>>> explorarPlataformas(
      {String busqueda = ""}) async {
    try {
      // CORREGIDO: Ruta actualizada para coincidir con el router
      final url = Uri.parse('$baseUrl/explorar?busqueda=$busqueda');

      print('Llamando a URL: $url'); // Debug

      final response = await http.get(url, headers: defaultHeaders);
      
      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        return ApiResponse.success(
            data: responseData['data'],
            message: responseData['mensaje'] ?? 'Plataformas encontradas');
      } else {
        return ApiResponse.error(
            message: responseData['mensaje'] ?? 'Error al buscar plataformas');
      }
    } catch (e) {
      print('Error en explorarPlataformas: $e'); // Debug
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

  // Listar plataformas activas 
  static Future<ApiResponse<List<dynamic>>> plataformasActivas() async {
    try {
      // CORREGIDO: Ruta actualizada para coincidir con el router
      final url = Uri.parse('$baseUrl/explorarActivas');

      print('Llamando a URL: $url'); // Debug

      final response = await http.get(url, headers: defaultHeaders);
      
      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        return ApiResponse.success(
            data: responseData['data'],
            message: responseData['mensaje'] ?? 'Plataformas activas');
      } else {
        return ApiResponse.error(
            message: responseData['mensaje'] ?? 'Error al cargar plataformas');
      }
    } catch (e) {
      print('Error en plataformasActivas: $e'); // Debug
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }

  // Obtener las plataformas de un usuario específico
  static Future<ApiResponse<List<dynamic>>> misPlataformas({
    required int idUsuario,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/misPlataformas?idUsuario=$idUsuario');

      print('Llamando a URL: $url'); // Debug

      final response = await http.get(url, headers: defaultHeaders);
      
      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['ok'] == true) {
        return ApiResponse.success(
            data: responseData['data'],
            message: responseData['mensaje'] ?? 'Plataformas del usuario obtenidas');
      } else {
        return ApiResponse.error(
            message: responseData['mensaje'] ?? 'Error al obtener las plataformas del usuario');
      }
    } catch (e) {
      print('Error en misPlataformas: $e'); // Debug
      return ApiResponse.error(
          message:
              'Error de conexión. Verifica tu internet y que la API esté funcionando.');
    }
  }


  // Test específico para rutas de plataformas
  static Future<Map<String, bool>> testPlatformRoutes() async {
    final results = <String, bool>{};
    
    try {
      // Test ruta de plataformas activas
      final activasUrl = Uri.parse('$baseUrl/explorarActivas');
      final activasResponse = await http.get(activasUrl).timeout(const Duration(seconds: 5));
      results['activas'] = activasResponse.statusCode == 200;
      
      // Test ruta de explorar
      final explorarUrl = Uri.parse('$baseUrl/explorar');
      final explorarResponse = await http.get(explorarUrl).timeout(const Duration(seconds: 5));
      results['explorar'] = explorarResponse.statusCode == 200;
      
    } catch (e) {
      print('Error testing platform routes: $e');
    }
    
    return results;
  }

  // ------------------ UNIRSE A PLATAFORMAS ------------------ //

// Unirse a una plataforma pública
static Future<ApiResponse<bool>> joinPublicPlatform({
  required int idUsuario,
  required int idPlataforma,
}) async {
  try {
    final url = Uri.parse('$baseUrl/unirsePublico');
    final body = json.encode({
      'idUsuario': idUsuario,
      'idPlataforma': idPlataforma,
    });

    final response = await http.post(url, headers: defaultHeaders, body: body);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.success(
        data: true,
        message: responseData['mensaje'] ?? 'Unido a la plataforma pública',
      );
    } else {
      return ApiResponse.error(
        message: responseData['mensaje'] ?? 'Error al unirse a la plataforma pública',
      );
    }
  } catch (e) {
    return ApiResponse.error(
      message: 'Error de conexión. Verifica tu internet y que la API esté funcionando.',
    );
  }
}

// Unirse a una plataforma privada (requiere código)
static Future<ApiResponse<bool>> joinPrivatePlatform({
  required int idUsuario,
  required int idPlataforma,
  required String codigo,
}) async {
  try {
    final url = Uri.parse('$baseUrl/unirsePrivado');
    final body = json.encode({
      'idUsuario': idUsuario,
      'idPlataforma': idPlataforma,
      'codigo': codigo,
    });

    final response = await http.post(url, headers: defaultHeaders, body: body);
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.success(
        data: true,
        message: responseData['mensaje'] ?? 'Unido a la plataforma privada',
      );
    } else {
      return ApiResponse.error(
        message: responseData['mensaje'] ?? 'Error al unirse a la plataforma privada',
      );
    }
  } catch (e) {
    return ApiResponse.error(
      message: 'Error de conexión. Verifica tu internet y que la API esté funcionando.',
    );
  }
}



  // ------------------ LOCAL STORAGE ------------------ //

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));
  }

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
      return null;
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/test');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
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
