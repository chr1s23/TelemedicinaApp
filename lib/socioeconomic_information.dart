import 'package:chatbot/terms_and_conditions.dart';
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
    "NINGUNO"
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
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 50,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar",
                  style: TextStyle(
                      color: Color.fromRGBO(165, 16, 8, 1), fontSize: 12))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Información Socioeconómica",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Nivel de instrucción
              _buildLabel("Nivel de instrucción"),
              _buildDropdown(_educationLevels, _selectedEducationLevel,
                  (newValue) {
                setState(() {
                  _selectedEducationLevel = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Ingresos mensuales
              _buildLabel("Ingresos mensuales"),
              _buildDropdown(_incomeLevels, _selectedIncome, (newValue) {
                setState(() {
                  _selectedIncome = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Trabajo remunerado
              _buildLabel("¿Tiene trabajo remunerado?"),
              _buildDropdown(_workStatusOptions, _selectedWorkStatus,
                  (newValue) {
                setState(() {
                  _selectedWorkStatus = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Ocupación principal
              _buildLabel("Ocupación principal"),
              TextFormField(
                controller: _occupationController,
                style: TextStyle(fontSize: 15, color: Colors.black),
                decoration: _inputDecoration(
                    "Ejemplo: Docente, Ingeniero, Comerciante"),
              ),

              const SizedBox(height: 20),

              // Recibe bono
              _buildLabel("¿Recibe bono?"),
              _buildDropdown(_bonusOptions, _selectedBonus, (newValue) {
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: const Color.fromRGBO(111, 111, 111, 1),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedItem,
      ValueChanged<String?> onChanged, String hint) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      decoration: _inputDecoration(hint),
      style: TextStyle(fontSize: 15, color: Colors.black),
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: Color.fromRGBO(111, 111, 111, 1), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
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
              //agregar la logica para guardar los campos que si estan llenos de informacion
              //add the form aggregation acept terms and conditions here
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()));
            },
            child: Text(
              "Continuar",
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions()));
              },
              child: Text(
                "En otro momento",
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
