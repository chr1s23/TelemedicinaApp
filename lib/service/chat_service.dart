import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:logging/logging.dart';

final _log = Logger('ChatService');

class ChatService {
  late socket_io.Socket socket;
  String sesionId = "a689c9c374a744efa19d498c68f54172";

  void connect() {
    socket = socket_io.io(
      'https://appclias.ucuenca.edu.ec', // IP del servidor Rasa
      socket_io.OptionBuilder()
          .setTransports(['websocket']) // Usa WebSockets
          .disableAutoConnect() // Para controlar la conexión manualmente
          .build(),
    );

    socket.connect();

    // Manejo de eventos
    socket.onConnect((_) {
      socket.emit('session_request', {"session_id": sesionId});
    });

    socket.onDisconnect((_) {
      _log.info("Desconectado de Rasa");
    });
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
}
