import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/generated/l10n.dart';
import '../models/user.dart';
import '../models/chat.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../services/socket.dart';

class ChatUser extends StatefulWidget {
  final Function(Locale)? onLocaleChange;
  final VoidCallback? onThemeToggle;
  final int idChat;
  final int idUsuarioEmisor;
  final int idUsuarioReceptor;
  final String nombreUsuarioReceptor;

  const ChatUser({
    Key? key,
    this.onLocaleChange,
    this.onThemeToggle,
    required this.idChat,
    required this.idUsuarioEmisor,
    required this.idUsuarioReceptor,
    required this.nombreUsuarioReceptor,
  }) : super(key: key);

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageItem> _messages = [];
  bool _isSending = false;
  late int currentUserId;

  @override
  void dispose() {
    socket.dispose(); // Cierra la conexión del socket
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 👇 Nuevo: índice de bottom nav
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _connectSocket();
    currentUserId = widget.idUsuarioEmisor;
    _loadMessages();
  }

  void _connectSocket() {
    socket = SocketService.getSocket();

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Conectado al socket: ${socket.id}');
      socket.emit('joinRoom', widget.idChat);
    });

    socket.on('newMessage', (data) {
      if (!mounted) return;
      setState(() {
        _messages.add(MessageItem.fromJson(data));
      });
      _scrollToBottom();
    });
  }

  Future<void> _loadMessages() async {
    final response = await ApiService.fetchChatMessages(
      widget.idUsuarioEmisor,
      widget.idUsuarioReceptor,
    );

    if (response.success && response.data != null) {
      setState(() {
        _messages =
            response.data!
                .map<MessageItem>((msg) => MessageItem.fromJson(msg))
                .toList();
      });
      _scrollToBottom();
    } else {
      debugPrint("Error cargando mensajes: ${response.message}");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    final messageText = _messageController.text;

    final response = await ApiService.sendMessage(
      idEmisor: widget.idUsuarioEmisor,
      idReceptor: widget.idUsuarioReceptor,
      mensaje: messageText,
    );

    if (response.success) {
      socket.emit('sendMessage', {
        'idChat': widget.idChat,
        'idUsuarioEmisor': widget.idUsuarioEmisor,
        'idUsuarioReceptor': widget.idUsuarioReceptor,
        'mensaje': messageText,
        'fecha': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _messageController.clear();
        _isSending = false;
        setState(() {}); // 🔹 solo para refrescar estado del input
      }
      _scrollToBottom();
    } else {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message ?? "Error")));
    }
  }

  // 👇 Nuevo: función para navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/chats',
        ); // 👈 Pantalla de chats
        break;
      case 2:
        Navigator.pushNamed(context, '/institutions');
        break;
      case 3:
        Navigator.pushNamed(context, '/calendar');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar
          // ----- Top bar con logo y notificaciones -----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/logo_dark.png'
                      : 'assets/logo.png',
                  width: 80, // más pequeño
                  height: 80, // más pequeño
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.star_outline,
                      size: 80,
                      color: Color(0xFF41277A),
                    );
                  },
                ),
                Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 24,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors
                                  .white // color en modo oscuro
                              : Colors.black54, // color en modo claro
                    ),
                    Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ----- Barra de contacto -----
          Container(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(
                      255,
                      44,
                      44,
                      44,
                    ) // color en modo oscuro
                    : const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // color en modo claro
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _messages.isNotEmpty
                          ? _messages
                                      .firstWhere(
                                        (msg) =>
                                            msg.fromUserId ==
                                            widget.idUsuarioReceptor,
                                        orElse:
                                            () => MessageItem(
                                              fromUserId: 0,
                                              toUserId: 0,
                                              message: '',
                                              timestamp: DateTime.now(),
                                              fotoPerfil: null,
                                            ),
                                      )
                                      .fotoPerfil !=
                                  null
                              ? MemoryImage(
                                _messages
                                    .firstWhere(
                                      (msg) =>
                                          msg.fromUserId ==
                                          widget.idUsuarioReceptor,
                                    )
                                    .fotoPerfil!,
                              )
                              : null
                          : null,
                  child:
                      (_messages.isEmpty ||
                              _messages
                                      .firstWhere(
                                        (msg) =>
                                            msg.fromUserId ==
                                            widget.idUsuarioReceptor,
                                        orElse:
                                            () => MessageItem(
                                              fromUserId: 0,
                                              toUserId: 0,
                                              message: '',
                                              timestamp: DateTime.now(),
                                              fotoPerfil: null,
                                            ),
                                      )
                                      .fotoPerfil ==
                                  null)
                          ? Text(
                            widget.nombreUsuarioReceptor.isNotEmpty
                                ? widget.nombreUsuarioReceptor[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          )
                          : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.nombreUsuarioReceptor,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ) // color en modo claro // color en modo oscuro
                              : const Color.fromARGB(
                                255,
                                44,
                                44,
                                44,
                              ), // color en modo claro
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.fromUserId == currentUserId;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 👈 Avatar del receptor
                      if (!isMe)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              msg.fotoPerfil != null
                                  ? MemoryImage(msg.fotoPerfil!)
                                  : null,
                          child:
                              msg.fotoPerfil == null
                                  ? const Icon(Icons.person, size: 16)
                                  : null,
                        ),
                      if (!isMe) const SizedBox(width: 6),

                      // Burbuja de mensaje
                      Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                              0.7, // 70% del ancho de pantalla
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe ? const Color(0xFF41277A) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          msg.message,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input de mensaje
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: S.of(context).Write_Message,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon:
                      _isSending
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send, color: Color(0xFF41277A)),
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),

      // 👇 Nuevo: BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(
                  255,
                  65,
                  65,
                  65,
                ) // gris oscuro en modo oscuro
                : Colors.white, // blanco en modo claro,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF41277A),
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class MessageItem {
  final int fromUserId;
  final int toUserId;
  final String message;
  final DateTime timestamp;
  final Uint8List? fotoPerfil;

  MessageItem({
    required this.fromUserId,
    required this.toUserId,
    required this.message,
    required this.timestamp,
    this.fotoPerfil,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    Uint8List? foto;
    if (json['fotoPerfil'] != null) {
      if (json['fotoPerfil'] is String) {
        foto = base64Decode(json['fotoPerfil']);
      } else if (json['fotoPerfil'] is Map &&
          json['fotoPerfil']['data'] != null) {
        foto = Uint8List.fromList(List<int>.from(json['fotoPerfil']['data']));
      }
    }

    return MessageItem(
      fromUserId: int.parse(json['idUsuarioEmisor'].toString()),
      toUserId: int.parse(json['idUsuarioReceptor'].toString()),
      message: json['mensaje'] ?? '',
      timestamp: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      fotoPerfil: foto,
    );
  }
}
