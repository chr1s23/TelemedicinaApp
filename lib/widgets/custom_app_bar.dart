import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true, // Asegura que la imagen esté centrada
      title: Image.asset(
        'assets/images/logo_ucuenca_top.png', // Ruta de la imagen en la carpeta assets
        height: 50, // Ajusta la altura según necesites
      ),
    );
  }
}
