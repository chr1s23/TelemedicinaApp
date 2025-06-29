class AppConfig {
  static const bool isDevelopment = false; // ⚠️ CAMBIA A FALSE si es producción
  static const bool usingEmulator = false; // ⚠️ CAMBIA A FALSE si usas dispositivo real

  static String get baseUrl {
    if (isDevelopment) {
      return usingEmulator
          ? "http://10.0.2.2:8080"       // Emulador
          : "http://10.24.161.93:8080";  // Dispositivo real (reemplaza con tu IP local)
    } else {
      return "https://clias.ucuenca.edu.ec"; // Producción
    }
  }
}