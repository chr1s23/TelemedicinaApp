class AppConfig {
  static const bool isDevelopment = false; // CAMBIAR A FALSE si es producción
  static const bool usingEmulator = false; // CAMBIAR A FALSE si usas dispositivo real

  static String get baseUrl {
    if (isDevelopment) {
      return usingEmulator
          ? "http://10.0.2.2:8080"       // Emulador
          : "http://192.168.18.4:8080";  // Dispositivo real (reemplaza con la IP local)
    } else {
      return "https://clias.ucuenca.edu.ec"; // Producción
    }
  }
}