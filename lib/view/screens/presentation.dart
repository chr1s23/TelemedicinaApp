import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Presentation extends StatefulWidget {
  const Presentation({super.key});

  @override
  State<Presentation> createState() => _PresentacionState();
}

class _PresentacionState extends State<Presentation> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "HELPY",
      "subtitle": "¡Cuidamos tu salud!",
      "image": "assets/images/helpy.jpg",
    },
    {
      "title": "Infórmate con nuestro Asistente Virtual",
      "subtitle": "",
      "image": "assets/images/av.jpg",
    },
    {
      "title": "Aprende de autocuidado con nosotros",
      "subtitle": "",
      "image": "assets/images/libro.png",
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _buildSlide(
                  _slides[index]["title"]!,
                  _slides[index]["subtitle"]!,
                  _slides[index]["image"]!,
                );
              },
            ),
          ),
          _buildIndicators(), // Indicadores del carrusel
          const SizedBox(height: 20),
          _buildButtons(), // Botones de "Crear cuenta" e "Iniciar sesión"
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSlide(String title, String subtitle, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subtitle,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 40),
        Image.asset(
          imagePath,
          height: 300,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentIndex == index ? 12 : 8,
          height: _currentIndex == index ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? const Color.fromRGBO(0, 40, 86, 1)
                : Color.fromRGBO(111, 111, 111, 1),
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
              backgroundColor: const Color.fromRGBO(0, 40, 86, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Text(
              "Iniciar Sesión",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text(
                "Crear una cuenta",
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
