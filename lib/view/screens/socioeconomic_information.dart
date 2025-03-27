import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/view/screens/terms_and_conditions.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class SocioeconomicInformation extends StatefulWidget {
  const SocioeconomicInformation({super.key});

  @override
  State<SocioeconomicInformation> createState() =>
      _SocioeconomicInfoFormState();
}

class _SocioeconomicInfoFormState extends State<SocioeconomicInformation> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEducationLevel;
  String? _selectedIncome;
  String? _selectedWorkStatus;
  String? _selectedBonus;
  final TextEditingController _occupationController = TextEditingController();

  final List<String> _educationLevels = [
    "NINGUNO",
    "PRIMARIA",
    "SECUNDARIA",
    "UNIVERSITARIA",
    "CENTRO DE ALBAFETIZACIÓN"
  ];

  final List<String> _incomeLevels = [
    "Menos de \$450",
    "\$450 - \$900",
    "\$901 - \$1350",
    "Más de \$1350"
  ];

  final List<String> _workStatusOptions = ["SI", "NO", "NOSE"];
  final List<String> _bonusOptions = ["SI", "NO", "NOSE"];

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
                  message: "¿Desea cancelar la creación de su cuenta? Se perderán todos los datos ingresados.", 
                  onYes: () => Navigator.of(context)..pop()..pop()..pop(),
                );
              },
              child: Text("Cancelar",
                  style: TextStyle(
                      color: AllowedColors.red, fontSize: 12))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Información Socioeconómica",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AllowedColors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Nivel de instrucción
              buildLabel("Nivel de instrucción"),
              buildDropdown(_educationLevels, _selectedEducationLevel,
                  (newValue) {
                setState(() {
                  _selectedEducationLevel = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Ingresos mensuales
              buildLabel("Ingresos mensuales"),
              buildDropdown(_incomeLevels, _selectedIncome, (newValue) {
                setState(() {
                  _selectedIncome = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Trabajo remunerado
              buildLabel("¿Tiene trabajo remunerado?"),
              buildDropdown(_workStatusOptions, _selectedWorkStatus,
                  (newValue) {
                setState(() {
                  _selectedWorkStatus = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Ocupación principal
              buildLabel("Ocupación principal"),
              TextFormField(
                controller: _occupationController,
                style: TextStyle(fontSize: 15, color: AllowedColors.black),
                decoration: inputDecoration(
                    "Ejemplo: Profesor, Comerciante"),
              ),

              const SizedBox(height: 20),

              // Recibe bono
              buildLabel("¿Recibe bono?"),
              buildDropdown(_bonusOptions, _selectedBonus, (newValue) {
                setState(() {
                  _selectedBonus = newValue;
                });
              }, 'Elija una opción'),
              const SizedBox(height: 30),
              Center(child: _buildButtons())
            ],
          ),
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
              backgroundColor: AllowedColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              //agregar la logica para guardar los campos que si estan llenos de informacion
              UserRequest? user = UserRequest.getUserRequest();

              if (user != null) {
                InfSocioeconomicaRequest socioeconomica = InfSocioeconomicaRequest(
                  _selectedEducationLevel,
                  _selectedIncome,
                  _selectedWorkStatus,
                  _occupationController.text,
                  _selectedBonus,
                );

                user.paciente.infoSocioeconomica = socioeconomica;
              }
              
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions()));
            },
            child: Text(
              "Continuar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AllowedColors.white,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()));
              },
              child: Text(
                "En otro momento",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AllowedColors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
