import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/register.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditions> {
  bool _acceptedTerms = false;

  void _submit() {
    if (_acceptedTerms) {
      //agregar la logica para guardar toda la informacion en el servidor en la base de datos
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes aceptar los términos y condiciones")),
      );
    }
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
                //agregar la logica para borrar todo el formulario y regresar a la pagina de registro
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Cancelar",
                  style: TextStyle(
                      color: Color.fromRGBO(165, 16, 8, 1), fontSize: 12))),
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
                      "Términos y Condiciones",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 400, // Espacio grande para los términos
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(111, 111, 111, 1), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Text(
                          "Aquí van los términos y condiciones de la aplicación.\n\n"
                          "1. Aceptación de términos.\n"
                          "2. Uso de la información.\n"
                          "3. Responsabilidad del usuario.\n"
                          "4. Privacidad y seguridad.\n"
                          "5. Derechos y obligaciones.\n"
                          "6. Modificaciones y actualizaciones.\n"
                          "7. Contacto y soporte.\n\n"
                          "Al aceptar estos términos, confirma que ha leído y entendido "
                          "las políticas de uso de la aplicación.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Checkbox con texto clickeable
            InkWell(
              onTap: () {
                setState(() {
                  _acceptedTerms = !_acceptedTerms; // Alternar estado
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    activeColor: const Color.fromRGBO(0, 40, 86, 1),
                  ),
                  Expanded(
                    child: Text(
                      "He leído y acepto los términos",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _acceptedTerms
                      ? const Color.fromRGBO(0, 40, 86, 1)
                      : Color.fromRGBO(111, 111, 111, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _acceptedTerms ? _submit : null,
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
