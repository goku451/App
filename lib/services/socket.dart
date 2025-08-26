import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  static IO.Socket getSocket() {
    if (_socket == null) {
      _socket = IO.io('http://192.168.1.6:3000', {
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
      });
    }
    return _socket!;
  }
}