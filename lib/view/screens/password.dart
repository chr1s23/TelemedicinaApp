import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/screens/login.dart';
import 'package:chatbot/view/widgets/custom_input_field.dart';
import 'package:chatbot/view/widgets/custom_loading_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void confirmChange() async {
    FocusScope.of(context).unfocus();
    if (_isLoading) return; // Evita múltiples clics

    setState(() {
      _isLoading = true;
    });

    User user = User("", _usernameController.value.text,
        _passwordController.value.text, null);
    bool success = await AuthService.changePassword(context, user);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      _usernameController.clear();
      _passwordController.clear();
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
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 50,
        ),
        actions: [
          TextButton(
              onPressed: () {
                modalYesNoDialog(
                  context: context,
                  title: "¿Cancelar?",
                  message: "¿Desea cancelar el cambio de contraseña?",
                  onYes: () => Navigator.of(context)..pop(),
                );
              },
              child: Text("Cancelar",
                  style: TextStyle(color: AllowedColors.red, fontSize: 12))),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Cambio de contraseña",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AllowedColors.black),
                  ),
                  Text(
                    "Ingresa a tu nombre de usuario para el cambio de contraseña.",
                    style: TextStyle(fontSize: 13, color: AllowedColors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Número de teléfono*",
                        style:
                            TextStyle(fontSize: 12, color: AllowedColors.gray)),
                  ),
                  CustomInputField(
                      controller: _usernameController,
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
                      "Contraseña nueva*",
                      style: TextStyle(fontSize: 12, color: AllowedColors.gray),
                    ),
                  ),
                  CustomInputField(
                      controller: _passwordController,
                      hint: 'Ingresa tu contraseña nueva (min. 6 caracteres)',
                      obscureText: true,
                      errorMessage: "Contraseña vacía",
                      isNumber: false),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      CustomLoadingButton(
                          color: AllowedColors.blue,
                          label: "Cambiar contraseña",
                          loading: _isLoading,
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (_passwordController.text.length < 6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "La contraseña debe tener al menos 6 caracteres.")));
                                      return;
                                    }
                                    confirmChange();
                                  }
                                }),
                      const SizedBox(height: 15)
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
