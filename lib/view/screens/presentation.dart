import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/custom_ink_well.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Presentation extends StatelessWidget {
  const Presentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SISA",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "¡Cuidamos tu salud!",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  "assets/images/sisa.png",
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ],
            )),
            const SizedBox(height: 20),
            Column(
              children: [
                CustomButton(
                    color: AllowedColors.blue,
                    label: "Iniciar Sesión",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }),
                const SizedBox(height: 15),
                CustomInkWell(
                    label: "Crear una cuenta",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    }, color: AllowedColors.red,),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
