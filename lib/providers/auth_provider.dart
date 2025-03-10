import 'package:chatbot/model/responses/user_response.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

    UserResponse? userInfo;

    Future<void> stablishUser(UserResponse user) async {
        userInfo = user;
        notifyListeners();
    }

    UserResponse? getLoggedUser() => userInfo;

    void logoutUser() {
        userInfo = null;
        notifyListeners();
    }
}