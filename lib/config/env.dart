class AppConfig {
  static const bool isDevelopment = false; // ⚠️ CAMBIA A FALSE si es producción
  static const bool usingEmulator = false; // ⚠️ CAMBIA A FALSE si usas dispositivo real

  static String get baseUrl {
    if (isDevelopment) {
      return usingEmulator
          ? "http://192.168.1.7:8080"       // Emulador
          : "http://192.168.1.78:8080";  // Dispositivo real (reemplaza con tu IP local)
    } else {
      return "https://clias.ucuenca.edu.ec"; // Producción
    }
  }

  static String get appVersion {
    return "1.0.5"; // Ir actualizando con cada versión
  }


}