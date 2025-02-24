import 'package:chatbot/model/responses/user_response.dart';
import 'package:chatbot/service/auth_service.dart';
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
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  User user = User("", "");

  void login() async {
    if (_isLoading) return; // Evita múltiples clics

    setState(() {
      _isLoading = true;
    });

    UserResponse? userLogged = await authService.login(context, user);
    if (userLogged != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
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
                  AppBar(
                    elevation: 0,
                    centerTitle: true, // Asegura que la imagen esté centrada
                    title: Image.asset(
                      'assets/images/logo_ucuenca_top.png', // Ruta de la imagen en la carpeta assets
                      height: 50, // Ajusta la altura según necesites
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Hola, bienvenido de nuevo!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    "Ingresa a tu cuenta para continuar",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Número de teléfono*",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(111, 111, 111, 1))),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.nombreUsuario),
                    onChanged: (val) {
                      user.nombreUsuario = val;
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'El número de teléfono está vacio';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu número de teléfono', // Placeholder
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(111, 111, 111, 1),
                          fontSize: 13), // Estilo del placeholder
                      errorStyle: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(165, 16, 8, 1)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(
                            30), // Borde redondeado opcional
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Contraseña*",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(111, 111, 111, 1)),
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
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu contraseña', // Placeholder
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(111, 111, 111, 1),
                          fontSize: 13), // Estilo del placeholder
                      errorStyle: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(165, 16, 8, 1)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(
                            30), // Borde redondeado opcional
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(111, 111, 111, 1),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildButtons(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 40, 86, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _isLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Previene null-safety issues
                      login();
                    }
                  },
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          height: 50,
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Crear una cuenta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(165, 16, 08, 1))),
            ),
          ),
        ),
      ],
    );
  }
}
