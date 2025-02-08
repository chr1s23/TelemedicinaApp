import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'register.dart';
import 'user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "");
  String url = "http://localhost:8080/usuarios/login";

  Future<void> save(BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url); // Convertir correctamente a Uri

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': user.correo,
          'contrasena': user.contrasena,
          'nombreUsuario': user.nombreUsuario,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ));
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 750,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 65, 82, 1),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(1, 5))
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text("Login",
                            style: GoogleFonts.pacifico(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Email",
                            style: GoogleFonts.roboto(
                              // fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController(text: user.correo),
                          onChanged: (val) {
                            user.correo = val;
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'El correo esta vacio';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        Container(
                          height: 8,
                          color: Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Password",
                            style: GoogleFonts.roboto(
                              // fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller:
                              TextEditingController(text: user.contrasena),
                          onChanged: (val) {
                            user.contrasena = val;
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return 'Correo esta vacio';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(fontSize: 20, color: Colors.black),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        Container(
                          height: 8,
                          color: Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text(
                              "No tienes una cuenta ?",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 90,
                  width: 90,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          233, 65, 82, 1), // Color de fondo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Previene null-safety issues
                        save(context);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
