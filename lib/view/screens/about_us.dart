import 'package:chatbot/utils/terms_conditions.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo_ucuenca_top.png',
            height: 50,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Acerca de",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AllowedColors.black),
                    ),
                    Text(
                      "VERSIÓN BETA",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AllowedColors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      //height: 400, // Espacio grande para los términos
                      decoration: BoxDecoration(
                        border: Border.all(color: AllowedColors.gray, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TermsConditions.aboutUs,
                            style: TextStyle(
                                fontSize: 12, color: AllowedColors.black),
                          ),
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/images/clias.jpg',
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          Image.asset(
                            'assets/images/idrc.png',
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
                color: AllowedColors.blue,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: "Entendido")
          ],
        ),
      ),
    );
  }
}
