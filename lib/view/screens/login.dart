import 'package:chatbot/model/responses/user_response.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/widgets/custom_ink_well.dart';
import 'package:chatbot/view/widgets/custom_input_field.dart';
import 'package:chatbot/view/widgets/custom_loading_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'register.dart';
import '../../model/requests/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (_isLoading) return; // Evita múltiples clics

    setState(() {
      _isLoading = true;
    });

    User user = User("", usernameController.value.text, passwordController.value.text, null);
    UserResponse? userLogged = await AuthService.login(context, user);

    if (userLogged != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true, // Asegura que la imagen esté centrada
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png', // Ruta de la imagen en la carpeta assets
          height: 50, // Ajusta la altura según necesites
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Hola, ¡Bienvenido de nuevo!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AllowedColors.black),
                  ),
                  Text(
                    "Ingresa a tu cuenta para continuar",
                    style: TextStyle(fontSize: 13, color: AllowedColors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Número de teléfono*",
                        style: TextStyle(
                            fontSize: 12,
                            color: AllowedColors.gray)),
                  ),
                  CustomInputField(
                      controller: usernameController,
                      hint: 'Ingresa tu número de teléfono',
                      obscureText: false,
                      errorMessage: "El número de teléfono está vacío",
                      isNumber: true),
                  SizedBox(
                    height: 38,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Contraseña*",
                      style: TextStyle(
                          fontSize: 12,
                          color: AllowedColors.gray),
                    ),
                  ),
                  CustomInputField(
                      controller: passwordController,
                      hint: 'Ingresa tu contraseña',
                      obscureText: true,
                      errorMessage: "Contraseña vacía",
                      isNumber: false),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CustomLoadingButton(
                          color: AllowedColors.blue,
                          label: "Iniciar Sesión",
                          loading: _isLoading,
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    login();
                                  }
                                }),
                      const SizedBox(height: 15),
                      CustomInkWell(
                          label: "Crear una cuenta",
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          })
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
