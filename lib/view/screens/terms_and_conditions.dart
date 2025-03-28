import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/model/responses/user_response.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/utils/terms_conditions.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditions> {
  bool _acceptedTerms = false;

  void _submit() async {
    if (_acceptedTerms) {
      UserRequest? user = UserRequest.getUserRequest();

      if (user != null) {
        user.aceptaConsentimiento = true;

        final doneLoading = modalLoadingDialog(context: context);

        UserResponse? userLogged = await AuthService.signUp(context, user);

        doneLoading();

        if (userLogged != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
        }
      } else {
        // TODO: Handle null case
      }
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
                modalYesNoDialog(
                  context: context,
                  title: "¿Cancelar?",
                  message:
                      "¿Desea cancelar la creación de su cuenta? Se perderán todos los datos ingresados.",
                  onYes: () => Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop()
                    ..pop(),
                );
              },
              child: Text("Cancelar",
                  style: TextStyle(color: AllowedColors.red, fontSize: 12))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Términos y Condiciones",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AllowedColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 500, // Espacio grande para los términos
                      decoration: BoxDecoration(
                        border: Border.all(color: AllowedColors.gray, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: Text(
                          TermsConditions.termsAndConditions,
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
                  _acceptedTerms = !_acceptedTerms;
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
                    activeColor: AllowedColors.blue,
                  ),
                  Expanded(
                    child: Text(
                      "He leído y acepto los términos y condiciones.",
                      style: TextStyle(
                        fontSize: 11,
                        color: AllowedColors.black,
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
                  backgroundColor:
                      _acceptedTerms ? AllowedColors.blue : AllowedColors.gray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _acceptedTerms ? _submit : null,
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AllowedColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
