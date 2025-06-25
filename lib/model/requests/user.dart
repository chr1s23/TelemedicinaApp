import 'package:chatbot/model/storage/storage.dart';
import 'package:logging/logging.dart';

final _log = Logger('User');

User? _currentUser;

class User {
  String nombre;
  String contrasena;
  String nombreUsuario;
  String? dispositivo;

  User(this.nombre, this.nombreUsuario, this.contrasena, this.dispositivo);

  static User getCurrentUser() {
    if (_currentUser == null) {
      _log.severe("Current user not set. User might not be logged in or state was improperly handled.");
    }
    return _currentUser!;
  }

  static setCurrentUser(User user, {bool save = true}) {
    _currentUser = user;

    if (save) {
      secureStorage.write(key: "user_name", value: user.nombre);
      secureStorage.write(key: "user_username", value: user.nombreUsuario);
    }
  }

  static clear() {
    secureStorage.delete(key: "user_id");
    secureStorage.delete(key: "user_token");
    secureStorage.delete(key: "user_name");
    secureStorage.delete(key: "user_username");
    secureStorage.delete(key: "user_device");

    _currentUser = null;
  }

  static Future<User?> loadUser() async {
    String? name = await secureStorage.read(key: "user_name");
    String? username = await secureStorage.read(key: "user_username");
    String? device = await secureStorage.read(key: "user_device");

    if (name != null && name.isNotEmpty && username != null && username.isNotEmpty) {
      return User(name, username, "*****", device);
    }

    return null;
  }
}