import 'package:chatbot/model/requests/paciente_request.dart';
import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/view/screens/socioeconomic_information.dart';
import 'package:chatbot/view/widgets/utils.dart';
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
        backgroundColor: AllowedColors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_ucuenca_top.png',
          height: 60,
        ),
        actions: [
          TextButton(
            onPressed: () {
              modalYesNoDialog(
                context: context, 
                title: "¿Cancelar?", 
                message: "¿Desea cancelar la creación de su cuenta? Se perderán todos los datos ingresados.", 
                onYes: () => Navigator.of(context)..pop()..pop(),
              );
            },
            child: Text("Cancelar",
              style: TextStyle(color: AllowedColors.red, fontSize: 12)
            )
          ),
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
                  color: AllowedColors.black,
                ),
              ),
              Text(
                  "Por favor, completa los siguientes campos con información válida",
                  style: TextStyle(
                    fontSize: 13,
                    color: AllowedColors.black,
                  )),
              const SizedBox(height: 20),

              // Fecha de nacimiento
              buildLabel("Fecha de nacimiento*"),
              TextFormField(
                controller: dateController,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 15, color: AllowedColors.black),
                  decoration: inputDecoration('dd/MM/yyyy', isCalendar: true),
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },),
              
              const SizedBox(height: 20),

              // País
              buildLabel("País*"),
              buildDropdown(_countries, _selectedCountry, (newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              }, 'Seleccione su país de origen', requiredInput: true),

              const SizedBox(height: 20),

              // Lengua materna
              buildLabel("Lengua Materna*"),
              buildDropdown(_languages, _selectedLanguage, (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }, 'Elija una opción', requiredInput: true),

              const SizedBox(height: 20),

              // Estado civil
              buildLabel("Estado Civil*"),
              buildDropdown(_maritalStatusOptions, _selectedMaritalStatus,
                  (newValue) {
                setState(() {
                  _selectedMaritalStatus = newValue;
                });
              }, 'Elija una opción', requiredInput: true),

              const SizedBox(height: 20),

              // Sexo
              buildLabel("Sexo*"),
              buildDropdown(_genders, _selectedGender, (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              }, 'Elija una opción', requiredInput: true),

              const SizedBox(height: 30),

              // Botón de continuar
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
                    if (_formKey.currentState?.validate() ?? false) {
                      User user = User.getCurrentUser();
                      //TODO: Handle edit
                      UserRequest.setUserRequest(
                        UserRequest(
                          user.nombreUsuario, 
                          user.contrasena, 
                          "USER", 
                          false,
                          PacienteRequest(
                            user.nombre, 
                            dateController.text, 
                            _selectedCountry!, 
                            _selectedLanguage!, 
                            _selectedMaritalStatus!, 
                            _selectedGender!, 
                            null
                          )
                        )
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocioeconomicInformation()
                        )
                      );
                    }
                  },
                  child: Text(
                    "Continuar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AllowedColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}