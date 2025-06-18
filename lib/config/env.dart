class AppConfig {
  static const bool isDevelopment = true; // CAMBIAR A FALSE si es producción
  static const bool usingEmulator = false; // CAMBIAR A FALSE si usas dispositivo real

  static String get baseUrl {
    if (isDevelopment) {
      return usingEmulator
          ? "http://10.0.2.2:8080"       // Emulador
          : "http://10.24.162.174:8080";  // Dispositivo real (reemplaza con la IP local)
    } else {
      return "https://clias.ucuenca.edu.ec"; // Producción
    }
  }
}