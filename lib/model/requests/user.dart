User? _currentUser;

class User {
  String nombre;
  String contrasena;
  String nombreUsuario;

  User(this.nombre, this.nombreUsuario, this.contrasena);

  static User getCurrentUser() {
    //TODO: Fetch user data
    _currentUser ??= User("Juan Pérez", "0912345678", "12345");
    return _currentUser!;
  }

  static setCurrentUser(User user) {
    _currentUser = user;
  }
}