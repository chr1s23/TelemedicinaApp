import 'package:chatbot/view/screens/socioeconomic_information.dart';
import 'package:flutter/material.dart';

class PersonalDataForm extends StatefulWidget {
  const PersonalDataForm({super.key});

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _countries = [
    "ECUADOR",
    "VENEZUELA",
    "COLOMBIA",
    "PERÚ",
    "CHILE",
    "ARGENTINA",
    "URUGUAY",
    "BRASIL",
    "MÉXICO",
  ];
  final List<String> _languages = ["ESPAÑOL", "INGLÉS", "OTRO"];
  final List<String> _maritalStatusOptions = [
    "SOLTERO/A",
    "CASADO/A",
    "DIVORCIADO/A",
    "VIUDO/A",
    "UNIÓN LIBRE"
  ];
  final List<String> _genders = ["MASCULINO", "FEMENINO", "OTRO"];

  final TextEditingController dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCountry;
  String? _selectedLanguage;
  String? _selectedMaritalStatus;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedCountry = _countries[0];
      _selectedLanguage = _languages[0];
      _selectedMaritalStatus = _maritalStatusOptions[0];
      _selectedGender = _genders[1];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2017),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        dateController.text = picked.toIso8601String().split("T")[0].split("-").reversed.join("/");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 60,
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
            children: [
              Text(
                "Datos Personales",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                  "Por favor, completa los siguientes campos con información válida",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  )),
              const SizedBox(height: 20),

              // Fecha de nacimiento
              _buildLabel("Fecha de nacimiento*"),
              TextFormField(
                controller: dateController,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  decoration: _inputDecoration('dd/MM/yyyy', isCalendar: true),
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },),
              
              const SizedBox(height: 20),

              // País
              _buildLabel("País*"),
              _buildDropdown(_countries, _selectedCountry, (newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              }, 'Seleccione su país de origen'),

              const SizedBox(height: 20),

              // Lengua materna
              _buildLabel("Lengua Materna*"),
              _buildDropdown(_languages, _selectedLanguage, (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Estado civil
              _buildLabel("Estado Civil*"),
              _buildDropdown(_maritalStatusOptions, _selectedMaritalStatus,
                  (newValue) {
                setState(() {
                  _selectedMaritalStatus = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 20),

              // Sexo
              _buildLabel("Sexo*"),
              _buildDropdown(_genders, _selectedGender, (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              }, 'Elija una opción'),

              const SizedBox(height: 30),

              // Botón de continuar
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SocioeconomicInformation()));
                    }
                  },
                  child: Text(
                    "Continuar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: const Color.fromRGBO(111, 111, 111, 1),
        ),
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
      validator: (value) => value == null ? "Campo obligatorio" : null,
    );
  }

  InputDecoration _inputDecoration(hint, {isCalendar = false}) {
    return InputDecoration(
      prefixIcon: isCalendar ? Icon(Icons.calendar_today) : null,
      hintText: hint, // Placeholder
      hintStyle: TextStyle(
          color: Color.fromRGBO(111, 111, 111, 1),
          fontSize: 13), // Estilo del placeholder
      errorStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(165, 16, 8, 1)),
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
        borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
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
    );
  }
}
