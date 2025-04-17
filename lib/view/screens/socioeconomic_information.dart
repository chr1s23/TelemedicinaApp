import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/view/screens/terms_and_conditions.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/custom_ink_well.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class SocioeconomicInformation extends StatefulWidget {
  const SocioeconomicInformation({super.key, this.infoSocioeconomicaRequest, this.edit = false});

  final InfSocioeconomicaRequest? infoSocioeconomicaRequest;
  final bool edit;

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

  @override
  void initState() {
    if (widget.infoSocioeconomicaRequest != null) {
      _selectedEducationLevel = widget.infoSocioeconomicaRequest!.instruccion;
      _selectedIncome = widget.infoSocioeconomicaRequest!.ingresos;
      _selectedWorkStatus = widget.infoSocioeconomicaRequest!.trabajoRemunerado;
      _selectedBonus = widget.infoSocioeconomicaRequest!.recibeBono;
      _occupationController.text = widget.infoSocioeconomicaRequest!.ocupacion ?? "";
    }
    super.initState();
  }

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
                  message:
                    widget.edit ?
                    "¿Desea cancelar la edición de su cuenta? Se perderán todos los datos ingresados." :
                    "¿Desea cancelar la creación de su cuenta? Se perderán todos los datos ingresados.",
                  onYes: () => Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop(),
                );
              },
              child: Text("Cancelar", style: TextStyle(color: AllowedColors.red, fontSize: 12))),
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
                decoration: inputDecoration("Ejemplo: Profesor, Comerciante"),
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
              Center(child: _buildButtons(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
            color: AllowedColors.blue,
            onPressed: () {
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

                if (widget.edit) {
                  final doneLoading = modalLoadingDialog(context: context);

                  PacienteService.update(context, user.paciente).then((value) {
                    doneLoading();

                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }

                    if (value) {
                      // ignore: use_build_context_synchronously
                      showSnackBar(context, "Edición exitosa");
                    }
                  });
                } else {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsAndConditions())
                  );
                }
              }
            },
            label: widget.edit ? "Guardar" : "Continuar"),
        const SizedBox(height: 20),
        if(!widget.edit) 
          CustomInkWell(
            label: "En otro momento",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndConditions()));
            }, color: AllowedColors.red,
          )
      ],
    );
  }
}
