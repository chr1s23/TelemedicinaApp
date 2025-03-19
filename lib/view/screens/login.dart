import 'package:chatbot/model/responses/user_response.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/custom_ink_well.dart';
import 'package:chatbot/view/widgets/custom_input_decoration.dart';
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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "");

  void login() async {
    FocusScope.of(context).unfocus();
    if (_isLoading) return; // Evita múltiples clics

    setState(() {
      _isLoading = true;
    });

    UserResponse? userLogged = await AuthService.login(context, user);
    if (userLogged != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        (route) => false
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomAppBar(),
                  SizedBox(
                    height: 20,
                  ),
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
                  TextFormField(
                      
                      controller:
                          TextEditingController(text: user.nombreUsuario),
                      onChanged: (val) {
                        user.nombreUsuario = val;
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'El número de teléfono está vacío';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15, color: AllowedColors.black),
                      decoration: CustomInputDecoration()
                          .getDecoration('Ingresa tu número de teléfono')),
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
                  TextFormField(
                      obscureText: true,
                      controller: TextEditingController(text: user.contrasena),
                      onChanged: (val) {
                        user.contrasena = val;
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Contraseña vacía';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15, color: AllowedColors.black),
                      decoration: CustomInputDecoration()
                          .getDecoration('Ingresa tu contraseña')),
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
