import 'package:chatbot/utils/resultado_utils.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
//import 'package:chatbot/view/screens/pdf_result_page.dart';
import 'package:chatbot/model/requests/encuesta_sus_request.dart';
import 'package:chatbot/service/encuesta_service.dart';
import 'package:chatbot/model/storage/storage.dart';

class LikertSurveyPage extends StatefulWidget {
  const LikertSurveyPage({super.key});

  @override
  State<LikertSurveyPage> createState() => _LikertSurveyPageState();
}

class _LikertSurveyPageState extends State<LikertSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final List<int?> _answers = List.generate(14, (index) => null);

  final List<String> _questions = [
    // SUS
    "Creo que me gustaría utilizar esta aplicación con frecuencia.",
    "Encontré la aplicación innecesariamente compleja.",
    "Pensé que la aplicación era fácil de usar.",
    "Creo que necesitaría ayuda de otra persona para poder usar esta aplicación correctamente.",
    "Encontré que las diversas funciones de esta aplicación estaban bien integradas.",
    "Necesitaba aprender muchas cosas antes de empezar con esta aplicación.",
    // Aceptabilidad
    "El asistente virtual me ayudó a comprender mejor temas sobre salud sexual.",
    "Usar este asistente virtual me facilitó obtener información confiable sobre salud sexual.",
    "Considero que el asistente es útil para resolver dudas comunes sobre salud sexual.",
    "Me resultó fácil interactuar con el asistente virtual.",
    "Las respuestas del asistente fueron claras y fáciles de entender.",
    "No necesité ayuda para usar el asistente correctamente.",
    "Me gustaría usar este asistente nuevamente si tengo dudas sobre salud sexual.",
    "Recomendaría este asistente virtual a otras personas que quieran informarse sobre salud sexual.",
  ];

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
                    "¿Desea cancelar la encuesta? Se perderán todos los datos ingresados.",
                onYes: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
              );
            },
            child: const Text("Cancelar",
                style: TextStyle(color: AllowedColors.red, fontSize: 12)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Encuesta de usabilidad del sistema y aceptabilidad",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AllowedColors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                "Es necesario completar esta encuesta para acceder al resultado de su examen.",
                style: TextStyle(fontSize: 13, color: AllowedColors.black),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Escala de respuestas:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text("1 = Muy en desacuerdo"),
                    Text("2 = En desacuerdo"),
                    Text("3 = Ni de acuerdo ni en desacuerdo"),
                    Text("4 = De acuerdo"),
                    Text("5 = Muy de acuerdo"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(_questions.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index + 1}. ${_questions[index]}",
                        style: const TextStyle(
                            fontSize: 15, color: AllowedColors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (i) {
                        final value = i + 1;
                        return ChoiceChip(
                          label: Text(value.toString()),
                          selected: _answers[index] == value,
                          onSelected: (selected) {
                            setState(() {
                              _answers[index] = value;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
              const SizedBox(height: 20),
              _buildButtons(context),
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
          onPressed: () async {
            if (_answers.contains(null)) {
              showSnackBar(context, "Por favor responda todas las preguntas.");
              return;
            }

            final cuentaUsuarioId = await secureStorage.read(key: "user_id");

            if (cuentaUsuarioId == null) {
              showSnackBar(context, "No se pudo obtener el ID de usuario.");
              return;
            }

            // Verificar si la encuesta está completada
            final completada =
                await EncuestaService.verificarEncuestaCompletada(
                    cuentaUsuarioId);
            print(
                "✅ ------------------------- Encuesta completada: $completada");

            if (completada) {
              await mostrarResultadoDesdeContexto(context);
            } else {
              // Si no está completada, guardar la encuesta
              final encuesta =
                  EncuestaSusRequest(_answers.cast<int>(), cuentaUsuarioId);
              final ok = await EncuestaService.guardarEncuesta(encuesta);

              if (!ok && context.mounted) {
                showSnackBar(context, "No se pudo guardar la encuesta.");
                return;
              }

              if (context.mounted) {
                await mostrarResultadoDesdeContexto(context);
              }
            }
          },
          label: "Ver Resultado",
        ),
      ],
    );
  }
}