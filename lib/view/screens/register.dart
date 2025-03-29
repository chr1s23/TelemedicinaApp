import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/view/screens/personal_data_form.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/custom_ink_well.dart';
import 'package:chatbot/view/widgets/custom_input_field.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Para navegar a la pantalla de inicio de sesión

class Register extends StatelessWidget {
  Register({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Crea una cuenta",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AllowedColors.black),
              ),
              Text(
                "Bienvenido, ingresa tus datos para comenzar a aprender!",
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
              const SizedBox(height: 30),
              // Nombre
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Nombre*",
                  style: TextStyle(fontSize: 12, color: AllowedColors.gray),
                ),
              ),
              CustomInputField(
                controller: _nameController,
                hint: "Ingresa tu nombre",
                obscureText: false,
                errorMessage: "Este campo es obligatorio",
                isNumber: false,
              ),
              const SizedBox(height: 20),
              // Nombre de usuario
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Número de teléfono*",
                  style: TextStyle(fontSize: 12, color: AllowedColors.gray),
                ),
              ),
              CustomInputField(
                controller: _usernameController,
                hint: "Ingresa tu número de teléfono (min. 7 digitos)",
                obscureText: false,
                errorMessage: "Este campo es obligatorio",
                isNumber: true,
              ),
              const SizedBox(height: 20),

              // Contraseña
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Contraseña*",
                  style: TextStyle(fontSize: 12, color: AllowedColors.gray),
                ),
              ),
              CustomInputField(
                controller: _passwordController,
                hint: "Ingresa tu contraseña (min. 6 caracteres)",
                obscureText: true,
                errorMessage: "Este campo es obligatorio",
                isNumber: false,
              ),
              const SizedBox(height: 20),

              // Confirmar contraseña
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Confirmar contraseña*",
                  style: TextStyle(fontSize: 12, color: AllowedColors.gray),
                ),
              ),
              CustomInputField(
                controller: _confirmPasswordController,
                hint: "Repite tu contraseña",
                obscureText: true,
                errorMessage: "Este campo es obligatorio",
                isNumber: false,
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  CustomButton(
                      color: AllowedColors.blue,
                      label: "Crear una cuenta",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_usernameController.text.length < 7) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "El número de teléfono es incorrecto.")));
                            return;
                          }
                          if (_passwordController.text.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "La contraseña debe tener al menos 6 caracteres.")));
                            return;
                          }
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Las contraseñas no coinciden. Por favor, inténtalo de nuevo.")));
                          } else {
                            User.setCurrentUser(User(
                                _nameController.text,
                                _usernameController.text,
                                _passwordController.text));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PersonalDataForm()));
                          }
                        }
                      }),
                  const SizedBox(height: 15),
                  CustomInkWell(
                      label: "Iniciar Sesión",
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
