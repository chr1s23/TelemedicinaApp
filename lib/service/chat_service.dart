import 'package:chatbot/model/storage/storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:logging/logging.dart';

final _log = Logger('ChatService');

class ChatService {
  late socket_io.Socket socket;

  Future<String> getSessionId() async {
    var sessionId = await secureStorage.read(key: "user_id");

    if (sessionId != null) {
      _log.fine("Clean session ID: $sessionId");
    } else {
      _log.severe("Session ID not found in secure storage.");
    }

    return sessionId!;
  }

  void connect() {
    socket = socket_io.io(
      'https://appclias.ucuenca.edu.ec', // IP del servidor Rasa
      socket_io.OptionBuilder()
          .setTransports(['websocket']) // Usa WebSockets
          .disableAutoConnect() // Para controlar la conexión manualmente
          .build(),
    );

    socket.connect();

    // Async anonymous call to avoid a race condition while correctly awaiting the session ID from secure storage
    () async {
      final sessionId = await getSessionId();

      // Manejo de eventos
      socket.onConnect((_) {
        socket.emit('session_request', {"session_id": sessionId});
      });

      socket.onDisconnect((_) {
        _log.info("Desconectado de Rasa");
      });
    }();
  }

  void sendMessage(String message, String senderId) {
    if (message.isEmpty) return;

    socket.emit('user_uttered', {
      'message': message,
      'session_id': senderId,
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  void reset(String senderId) {
    socket.emit('user_uttered', {
      'message': "/restart",
      'session_id': senderId,
    });
  }
}
