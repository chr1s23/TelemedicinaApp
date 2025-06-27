import 'package:chatbot/model/requests/paciente_request.dart';
import 'package:chatbot/view/screens/encuesta_sus.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';

class RequiredSocioeconomicForm extends StatefulWidget {
  final PacienteRequest paciente;

  const RequiredSocioeconomicForm({super.key, required this.paciente});

  @override
  State<RequiredSocioeconomicForm> createState() =>
      _RequiredSocioeconomicFormState();
}

class _RequiredSocioeconomicFormState extends State<RequiredSocioeconomicForm> {
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
  final List<String> _workStatusOptions = ["SI", "NO"];
  final List<String> _bonusOptions = ["SI", "NO"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AllowedColors.blue),
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Para continuar y acceder a tus resultados, necesitamos que completes esta información.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              buildLabel("Nivel de instrucción"),
              buildDropdown(
                  _educationLevels,
                  _selectedEducationLevel,
                  (value) => setState(() => _selectedEducationLevel = value),
                  'Seleccione una opción'),
              const SizedBox(height: 20),
              buildLabel("Ingresos mensuales"),
              buildDropdown(
                  _incomeLevels,
                  _selectedIncome,
                  (value) => setState(() => _selectedIncome = value),
                  'Seleccione una opción'),
              const SizedBox(height: 20),
              buildLabel("¿Tiene trabajo remunerado?"),
              buildDropdown(
                  _workStatusOptions,
                  _selectedWorkStatus,
                  (value) => setState(() => _selectedWorkStatus = value),
                  'Seleccione una opción'),
              const SizedBox(height: 20),
              buildLabel("Ocupación principal"),
              TextFormField(
                controller: _occupationController,
                decoration: inputDecoration("Ejemplo: Carpintera, Estudiante"),
              ),
              const SizedBox(height: 20),
              buildLabel("¿Recibe bono?"),
              buildDropdown(
                  _bonusOptions,
                  _selectedBonus,
                  (value) => setState(() => _selectedBonus = value),
                  'Seleccione una opción'),
              const SizedBox(height: 30),
              CustomButton(
                color: AllowedColors.blue,
                onPressed: _guardarYContinuar,
                label: "Guardar y continuar",
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardarYContinuar() async {
    final paciente = widget.paciente;

    print(
        "[X] Guardando información socioeconómica del paciente: ${paciente.nombre}");

    final info = InfSocioeconomicaRequest(
      _selectedEducationLevel,
      _selectedIncome,
      _selectedWorkStatus,
      _occupationController.text,
      _selectedBonus,
    );

    paciente.infoSocioeconomica = info;

    final cerrarDialogo = modalLoadingDialog(context: context);
    final success = await PacienteService.update(context, paciente);
    cerrarDialogo();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LikertSurveyPage()),
      );
    } else {
      showSnackBar(context, "Ocurrió un error al guardar la información.");
    }
  }
}
