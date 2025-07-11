import 'package:flutter/material.dart';

class BlogInfertilidadPage extends StatefulWidget {
  const BlogInfertilidadPage({super.key});

  @override
  State<BlogInfertilidadPage> createState() => _BlogInfertilidadPageState();
}

class _BlogInfertilidadPageState extends State<BlogInfertilidadPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Infertilidad", style: TextStyle(color: Colors.white)),
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
            Tab(text: '¿Qué es la infertilidad?'),
            Tab(text: 'Causas de la infertilidad'),
            Tab(text: 'Prevención'),
            Tab(text: 'Pruebas de diagnóstico'),
            Tab(text: 'Alternativas frente a la infertilidad'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Infertilidad.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es la infertilidad?', """
La infertilidad es una condición médica que se define como la incapacidad para lograr un embarazo después de 12 meses de relaciones sexuales regulares sin protección. Afecta tanto a mujeres como a hombres, y puede tener múltiples causas físicas, hormonales, genéticas o incluso desconocidas.

La OMS reconoce la infertilidad como una enfermedad del sistema reproductivo que puede provocar impacto emocional, social y económico en quienes la enfrentan. Se estima que entre el 8 % y el 12 % de las parejas en edad reproductiva en todo el mundo la experimentan.

En muchos casos, existen tratamientos o técnicas que pueden ayudar a lograr un embarazo, pero es importante buscar atención médica especializada para conocer la causa y las posibles soluciones.
"""),
                _buildTabContent('Causas de la infertilidad', """
La infertilidad puede tener su origen en cualquiera de los miembros de la pareja y, según la OMS, se debe a múltiples factores físicos, hormonales y ambientales.

En las mujeres, las causas más comunes son:

🔸 Problemas de ovulación, como el síndrome de ovario poliquístico.
🔸 Endometriosis o infecciones que afectan las trompas de Falopio.
🔸 Edad materna avanzada (más de 35 años).
🔸 Trastornos hormonales o del útero.

En los hombres, las causas incluyen:

🔸 Baja producción o calidad de espermatozoides.
🔸 Alteraciones genéticas o hormonales.
🔸 Varicocele (dilatación de venas en los testículos).
🔸 Infecciones, consumo de alcohol o tabaco, y exposición a sustancias tóxicas.

En el 15–30 % de los casos, la causa es desconocida.

Conocer la causa es el primer paso para buscar soluciones adecuadas.
"""),
                _buildTabContent('Prevención', """
Aunque no todos los casos de infertilidad se pueden prevenir, sí es posible reducir muchos de los factores de riesgo con hábitos saludables. Según la OMS, adoptar medidas de autocuidado desde edades tempranas ayuda a proteger la salud reproductiva.

En mujeres y hombres, se recomienda:

🔸 Evitar infecciones de transmisión sexual (ITS) usando condón y haciéndose pruebas periódicas.
🔸 No fumar ni abusar del alcohol o drogas, ya que afectan la calidad de óvulos y espermatozoides.
🔸 Mantener un peso saludable.
🔸 Evitar la exposición a sustancias tóxicas o radiación.
🔸 Atender problemas hormonales o enfermedades crónicas a tiempo.
🔸 En mujeres, evitar el uso prolongado de anticonceptivos sin seguimiento médico y realizar controles ginecológicos regulares.

Además, hablar abiertamente sobre salud reproductiva y consultar con profesionales en caso de dificultades ayuda a detectar problemas antes de que se agraven.
"""),
                _buildTabContent('Pruebas de diagnóstico', """
Si una pareja lleva más de 12 meses teniendo relaciones sexuales sin protección y no logra un embarazo, es momento de acudir al médico para una evaluación. Según la OMS, tanto mujeres como hombres deben realizarse pruebas para identificar la causa y orientar el tratamiento adecuado.

En mujeres, las pruebas más comunes incluyen:

🔸 Ecografías pélvicas para observar ovarios y útero.
🔸 Exámenes hormonales para detectar alteraciones en la ovulación.
🔸 Histerosalpingografía, que evalúa si las trompas de Falopio están obstruidas.
🔸 Papanicolaou y pruebas de ITS, en algunos casos.

En hombres:

🔸 Espermatograma, que analiza la cantidad, movilidad y forma de los espermatozoides.
🔸 Exámenes hormonales y físicos.

Ambos también pueden necesitar entrevistas médicas, análisis de estilo de vida y antecedentes. 
Estas pruebas son claves para conocer el motivo de la infertilidad y planificar opciones.
"""),
                _buildTabContent('Alternativas frente a la infertilidad', """
La infertilidad no significa el fin del deseo de ser madre o padre. Según la OMS, hoy existen diversas alternativas médicas y de acompañamiento emocional para ayudar a las personas o parejas con dificultades para concebir.

🔸 Tratamientos médicos: Dependiendo de la causa, se puede recurrir a medicamentos para estimular la ovulación, cirugía para corregir obstrucciones o infecciones, o tratamientos hormonales.
🔸 Reproducción asistida: Técnicas como la inseminación artificial o la fertilización in vitro (FIV) permiten unir el óvulo y el espermatozoide en un laboratorio y luego implantar el embrión. Donación de óvulos o esperma, y en algunos casos, vientre subrogado, según la legislación local.
🔸 Adopción: Es una opción legal y amorosa para formar familia, y puede ser considerada cuando no hay respuesta al tratamiento o por elección personal.

El apoyo emocional también es clave. Existen redes y profesionales especializados que acompañan este proceso.
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