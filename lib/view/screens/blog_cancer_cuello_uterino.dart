import 'package:flutter/material.dart';

class BlogCancerCuelloUterinoPage extends StatefulWidget {
  const BlogCancerCuelloUterinoPage({super.key});

  @override
  State<BlogCancerCuelloUterinoPage> createState() => _BlogCancerCuelloUterinoPageState();
}

class _BlogCancerCuelloUterinoPageState extends State<BlogCancerCuelloUterinoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cáncer de Cuello Uterino", style: TextStyle(color: Colors.white)),  
        backgroundColor: const Color.fromARGB(255, 0, 40, 86), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),  
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,  
          labelColor: Colors.white,  
          unselectedLabelColor: Colors.white54,  
          tabs: const [
            Tab(text: '¿Qué es?'),
            Tab(text: 'Causas'),
            Tab(text: 'Prevención'),
            Tab(text: 'Pruebas'),
            Tab(text: 'Síntomas'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ccu.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es el cáncer de cuello uterino?', """
El cáncer de cuello uterino es una enfermedad en la que las células del cuello del útero (la parte baja del útero que conecta con la vagina) crecen de forma descontrolada. Según la OMS, este tipo de cáncer es causado en la mayoría de los casos por una infección persistente del Virus del Papiloma Humano (VPH), especialmente por los tipos 16 y 18.

El desarrollo de este cáncer suele ser lento y puede tardar varios años en aparecer desde la infección inicial. Por eso es uno de los pocos tipos de cáncer que se puede prevenir y detectar a tiempo mediante pruebas como el Papanicolaou o el test de VPH.

Este tipo de cáncer afecta sobre todo a mujeres entre los 30 y 50 años, pero puede prevenirse con vacunación, detección temprana y tratamiento oportuno.

Cuidarse es posible, informarse es el primer paso.
"""),
                _buildTabContent('Causas', """
La principal causa del cáncer de cuello uterino es la infección persistente por Virus del Papiloma Humano (VPH), especialmente los tipos de alto riesgo como el VPH 16 y 18. Este virus se transmite por contacto sexual y, aunque la mayoría de las infecciones desaparecen solas, algunas pueden quedarse en el cuerpo y causar cambios en las células del cuello uterino que con el tiempo se convierten en cáncer.

Otras causas y factores que aumentan el riesgo incluyen:

🔸 Tener múltiples parejas sexuales o una pareja con muchas parejas previas
🔸 Inicio temprano de la actividad sexual
🔸 Fumar cigarrillos
🔸 Sistema inmunológico débil (por ejemplo, VIH)
🔸 No hacerse pruebas de detección regularmente
"""),
                _buildTabContent('Prevención', """
El cáncer de cuello uterino es uno de los pocos tipos de cáncer que se puede prevenir de forma efectiva. Según la OMS y la OPS, la prevención se basa en tres pilares fundamentales:

1. Vacunación contra el VPH: Protegerse desde la adolescencia con la vacuna contra el VPH reduce hasta un 90% el riesgo de desarrollar este cáncer.

2. Detección temprana: Realizarse pruebas como el Papanicolaou o el automuestreo vaginal de VPH permite identificar cambios celulares antes de que se vuelvan cáncer.

3. Hábitos saludables: Usar condón, evitar el tabaco y acudir a los controles ginecológicos son medidas que también disminuyen el riesgo.
"""),
                _buildTabContent('Pruebas', """
Detectar a tiempo el cáncer de cuello uterino puede salvar vidas. Según la OMS y la OPS, existen dos pruebas principales para identificar lesiones antes de que se conviertan en cáncer:

1. Papanicolaou (o citología): Esta prueba analiza células del cuello del útero para detectar cambios anormales. Se recomienda realizarla a partir de los 25 años, cada 1 a 3 años según indicación médica.

2. Test de VPH: Detecta directamente la presencia del Virus del Papiloma Humano (VPH) de alto riesgo. Puede realizarse mediante muestra tomada por un profesional o automuestreo vaginal.
"""),
                _buildTabContent('Síntomas', """
En sus primeras etapas, el cáncer de cuello uterino suele no presentar síntomas, por eso es tan importante realizarse pruebas como el Papanicolaou o el test de VPH. Sin embargo, cuando la enfermedad avanza, pueden aparecer señales de alerta que no deben ignorarse.

Los síntomas más comunes incluyen:

🔸Sangrado vaginal anormal, especialmente después de tener relaciones sexuales, entre periodos o después de la menopausia
🔸 Flujo vaginal con mal olor o aspecto inusual
🔸 Dolor pélvico o durante las relaciones sexuales
🔸 En etapas más avanzadas: dolor en la espalda, piernas o fatiga constante
"""),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTabContent(String title, String content) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black, 
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,  
            ),
          ],
        ),
      ),
    );
  }
}
