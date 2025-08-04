import 'package:flutter/material.dart';

class BlogViolenciaGeneroPage extends StatefulWidget {
  const BlogViolenciaGeneroPage({super.key});

  @override
  State<BlogViolenciaGeneroPage> createState() => _BlogViolenciaGeneroPageState();
}

class _BlogViolenciaGeneroPageState extends State<BlogViolenciaGeneroPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Violencia de Género", style: TextStyle(color: Colors.white)), 
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
            Tab(text: '¿Qué es la violencia de género?'),
            Tab(text: 'Signos de la violencia'),
            Tab(text: 'Tipos de violencia'),
            Tab(text: '¿Dónde denunciar?'),
            Tab(text: 'Derechos frente a la violencia'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/violencia2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es la violencia de género?', """
La violencia de género es cualquier acto dañino dirigido contra una persona debido a su género. Afecta principalmente a mujeres y niñas, pero también puede afectar a hombres y personas LGBTIQ+. Según la OMS, incluye violencia física, sexual, psicológica o económica, tanto en espacios públicos como privados.

Esta violencia se basa en desigualdades de poder y en estereotipos que asignan roles desiguales entre hombres y mujeres. Un ejemplo común es la violencia por parte de la pareja íntima, que puede incluir golpes, amenazas, abuso emocional o control económico.

La OPS destaca que al menos 1 de cada 3 mujeres en América Latina ha sufrido algún tipo de violencia de género, lo que representa un grave problema de salud pública y derechos humanos.
"""),
                _buildTabContent('Signos de la violencia', """
La violencia de género no siempre deja marcas visibles. Según la OMS y la OPS, puede manifestarse de muchas formas, y conocer sus signos ayuda a detectarla y actuar a tiempo.

Algunos signos emocionales y conductuales:

🔸 Miedo constante hacia la pareja
🔸 Aislamiento de familiares y amistades
🔸 Cambios bruscos de comportamiento o humor
🔸 Baja autoestima o tristeza frecuente

Signos físicos:

🔸 Golpes, moretones o heridas sin explicación clara
🔸 Vestimenta que intenta ocultar lesiones

Signos de control:

🔸 La pareja revisa el celular, limita salidas o controla el dinero
🔸 Desvalorización constante, insultos o amenazas
"""),
                _buildTabContent('Tipos de violencia', """
La violencia de género puede tomar muchas formas. Según la OMS y la OPS, no solo se trata de golpes o agresiones físicas; también incluye otros tipos de daño que afectan la salud, dignidad y libertad de las personas, especialmente mujeres y niñas.

Los principales tipos son:
🔸 Violencia física: empujones, golpes, quemaduras, estrangulación, entre otros.
🔸 Violencia sexual: cualquier acto sexual forzado o sin consentimiento, incluidas violaciones o abuso dentro de la pareja.
🔸 Violencia psicológica: insultos, humillaciones, amenazas, control o manipulación emocional.
🔸 Violencia económica: control del dinero, impedir que la persona trabaje o quitarle sus ingresos.
🔸 Violencia digital: acoso, amenazas o control a través de redes sociales o mensajes.
"""),
                _buildTabContent('¿Dónde denunciar?', """
Si tú o alguien que conoces sufre violencia de género, aquí tienes las opciones públicas más importantes:

🚨 Llamadas de emergencia:
911: para atención inmediata y derivación a policía o servicios de salud.

📞 Líneas de apoyo:
Consola Violeta: 4110‑110
Fundación María Amor: 072‎/‎832‑817 (línea activa las 24 h).

🏛️ Denuncias formales:
Junta Cantonal de Protección de Derechos: puede tramitar medidas urgentes.
Fiscalía Provincial del Azuay y la Unidad Judicial especializada en violencia contra la mujer y la familia: reciben denuncias físicas y sexuales.

🏠 Centros de atención integral:
Centro Violeta Cuenca (Parque La Libertad): brinda atención psicológica, legal y social.
Casa Violeta y Casa de Acogida María Amor: ofrecen refugio y acompañamiento profesional integral.
"""),
                _buildTabContent('Derechos frente a la violencia', """
Toda persona tiene derecho a vivir una vida libre de violencia, discriminación y miedo. Según la OMS, la violencia de género no solo es un problema social, sino una grave violación a los derechos humanos.

En Ecuador, la Constitución y la Ley Orgánica para Prevenir y Erradicar la Violencia contra las Mujeres reconocen los siguientes derechos:
🔸 A vivir una vida libre de violencia en todos los espacios (hogar, trabajo, comunidad).
🔸 A recibir atención médica, psicológica y legal gratuita y especializada.
🔸 A denunciar sin necesidad de tener pruebas físicas inmediatas.
🔸 A ser protegida con medidas cautelares (como orden de alejamiento).
🔸 A recibir justicia sin revictimización ni prejuicios.
🔸 A refugio seguro en casos de riesgo.
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
