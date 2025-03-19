import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AllowedColors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 50,
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/avatar.png'), // Imagen del avatar
              radius: 15,
            ),
            onPressed: () {
              // Acción del perfil
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Acerca de",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AllowedColors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 400, // Espacio grande para los términos
                      decoration: BoxDecoration(
                        border: Border.all(color: AllowedColors.gray, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Text(
                          "Aquí va la descripcion de la aplicacion, acerca de.....\n\n"
                          "1. Aceptación de términos.\n"
                          "2. Uso de la información.\n"
                          "3. Responsabilidad del usuario.\n"
                          "4. Privacidad y seguridad.\n"
                          "5. Derechos y obligaciones.\n"
                          "6. Modificaciones y actualizaciones.\n"
                          "7. Contacto y soporte.\n\n"
                          "Al aceptar estos términos, confirma que ha leído y entendido "
                          "las políticas de uso de la aplicación.",
                          style: TextStyle(fontSize: 12, color: AllowedColors.black)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllowedColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Entendido",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AllowedColors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
