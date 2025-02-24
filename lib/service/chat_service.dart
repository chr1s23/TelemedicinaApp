import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;
  String sesionId = "a689c9c374a744efa19d498c68f54172";

  void connect() {
    socket = IO.io(
      'https://adcd-179-49-41-121.ngrok-free.app', // IP del servidor Rasa
      IO.OptionBuilder()
          .setTransports(['websocket']) // Usa WebSockets
          .disableAutoConnect() // Para controlar la conexión manualmente
          .build(),
    );

    socket.connect();

    // Manejo de eventos
    socket.onConnect((_) {
      print('Conectado a Rasa');
      socket.emit('session_request', {"session_id": sesionId});
      print('Session request enviado con ID: $sesionId');
    });

    socket.on('session_confirm', (data) {
      print(
          "⚡ Sesión confirmada: $data"); // Confirma que Rasa reconoce la sesión
    });

    socket.onDisconnect((_) {
      print('Desconectado de Rasa');
    });
  }

  void sendMessage(String message, String senderId) {
    if (message.isEmpty) return;

    print('Enviando mensaje: "$message" con session_id: $sesionId');

    socket.emit('user_uttered', {
      'message': message,
      'session_id': senderId,
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
