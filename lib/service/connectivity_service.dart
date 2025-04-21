import 'package:dio/dio.dart';

class ConnectivityService {
  static Future<bool> hasInternetConnection() async {
    try {
      final response = await Dio().get(
        "https://www.google.com/generate_204",
        options: Options(
          receiveTimeout: Duration(seconds: 3),
          sendTimeout: Duration(seconds: 3),
        ),
      );
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
