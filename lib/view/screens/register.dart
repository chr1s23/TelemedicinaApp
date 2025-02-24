import 'package:chatbot/view/screens/personal_data_form.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Para navegar a la pantalla de inicio de sesión

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 50,
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
                    color: Colors.black),
              ),
              const SizedBox(height: 30),

              // Nombre
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Nombre*",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(111, 111, 111, 1)),
                ),
              ),
              _buildTextField(_nameController, "Ingresa tu nombre"),
              const SizedBox(height: 20),

              // Nombre de usuario
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Número de teléfono*",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(111, 111, 111, 1)),
                ),
              ),
              _buildTextField(
                  _usernameController, "Ingresa tu número de teléfono"),
              const SizedBox(height: 20),

              // Contraseña
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Contraseña*",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(111, 111, 111, 1)),
                ),
              ),
              _buildTextField(_passwordController, "Ingresa tu contraseña",
                  obscureText: true),
              const SizedBox(height: 20),

              // Confirmar contraseña
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Confirmar contraseña*",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(111, 111, 111, 1)),
                ),
              ),
              _buildTextField(
                  _confirmPasswordController, "Repite tu contraseña",
                  obscureText: true),
              const SizedBox(height: 30),
              _buildButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'Este campo no puede estar vacío';
        }
        return null;
      },
      style: TextStyle(fontSize: 15, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: Color.fromRGBO(111, 111, 111, 1), fontSize: 13),
        errorStyle:
            TextStyle(fontSize: 13, color: Color.fromRGBO(165, 16, 8, 1)),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
          borderRadius: BorderRadius.circular(30),
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
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalDataForm()));
              }
            },
            child: Text(
              "Crear una cuenta",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                "Iniciar Sesión",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(165, 16, 08, 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
