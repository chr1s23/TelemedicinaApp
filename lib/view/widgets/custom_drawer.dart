import 'package:chatbot/model/requests/paciente_request.dart';
import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/view/screens/about_us.dart';
import 'package:chatbot/view/screens/personal_data_form.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280, // Ajusta el tamaño del drawer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // Espaciado

          // Avatar del Usuario
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(height: 10),
          Text(
            User.getCurrentUser().nombre,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black),
          ),
          const SizedBox(height: 30),

          // Botones de Opciones
          _buildDrawerButton(Icons.person, "Perfil",
            () async {
              PacienteRequest? pacienteRequest = await PacienteService.getPaciente(context);

              if (pacienteRequest == null || !context.mounted) return;

              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PersonalDataForm(pacienteRequest: pacienteRequest, edit: true))
              );
            }
          ),
          _buildDrawerButton(Icons.info, "Acerca de", () {
            Navigator.pop(context); // Cierra el Drawer
            // Navegar a Acerca de
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AboutUs()));
          }),

          const Spacer(), // Empuja el botón "Cerrar sesión" hacia abajo

          // Botón Cerrar Sesión
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllowedColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra el Drawer
                  User.clear();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Presentation()), (route) => false);
                },
                child: Text(
                  "Cerrar sesión",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AllowedColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerButton(IconData icon, String label, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: AllowedColors.blue),
      title: Text(
        label,
        style: TextStyle(fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}