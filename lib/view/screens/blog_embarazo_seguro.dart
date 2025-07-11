import 'package:flutter/material.dart';

class BlogEmbarazoSeguroPage extends StatefulWidget {
  const BlogEmbarazoSeguroPage({super.key});

  @override
  State<BlogEmbarazoSeguroPage> createState() => _BlogEmbarazoSeguroPageState();
}

class _BlogEmbarazoSeguroPageState extends State<BlogEmbarazoSeguroPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Embarazo Seguro", style: TextStyle(color: Colors.white)),
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
            Tab(text: 'Alimentación'),
            Tab(text: 'Ejercicio'),
            Tab(text: 'Preparación para el parto'),
            Tab(text: 'Preeclampsia'),
            Tab(text: 'Riesgos'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/embarazo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('Alimentación en el embarazo', """
Una buena alimentación durante el embarazo es fundamental para la salud de la madre y el desarrollo del bebé. Según la OMS y la OPS, una dieta equilibrada ayuda a prevenir complicaciones como anemia, bajo peso al nacer o parto prematuro.

¿Qué debe incluir tu alimentación?
🔸 Frutas y verduras frescas todos los días.
🔸 Proteínas saludables, como carnes magras, huevo, legumbres y pescado (bien cocido).
🔸 Carbohidratos integrales, como arroz, avena y pan integral.
🔸 Lácteos bajos en grasa para fortalecer huesos y dientes.
🔸 Agua en abundancia, al menos 8 vasos al día.

Evita alimentos crudos, embutidos, cafeína en exceso y productos ultraprocesados. Además, la OMS recomienda tomar ácido fólico y hierro como suplementos durante el embarazo.

Comer bien es una forma de cuidar a tu bebé desde el primer día.
"""),
                _buildTabContent('Ejercicio en el embarazo', """
Hacer ejercicio durante el embarazo es seguro y beneficioso para la mayoría de las mujeres. Según la OMS y la OPS, ayuda a reducir molestias físicas, mejorar el ánimo, prevenir el aumento excesivo de peso y disminuir el riesgo de diabetes gestacional o parto complicado.

Se recomienda al menos 150 minutos de actividad física moderada por semana, distribuidos en varios días. Algunas opciones seguras son:

🔸 Caminatas suaves
🔸 Natación
🔸 Yoga prenatal
🔸 Ejercicios de respiración o estiramiento

Es importante evitar ejercicios de alto impacto, con riesgo de caídas o que exijan mucho esfuerzo abdominal. Antes de comenzar, consulta con el personal de salud, especialmente si el embarazo es de alto riesgo.

El movimiento, con cuidado y regularidad, es una forma de cuidar tu cuerpo y a tu bebé.
"""),
                _buildTabContent('Preparación para el parto', """
Prepararse para el parto ayuda a reducir el miedo, tomar decisiones informadas y vivir este momento con mayor seguridad. Según la OMS y la OPS, la preparación debe incluir información médica, apoyo emocional y planificación práctica.

Algunas claves importantes:

🔸 Asistir a los controles prenatales y hablar con tu médico sobre el plan de parto.
🔸 Conocer los signos de inicio del trabajo de parto, como contracciones regulares, ruptura de fuente o sangrado.
🔸 Participar en clases prenatales o de preparación al parto, donde se aprende sobre respiración, posiciones y cuidados del recién nacido.
🔸 Elegir con tiempo el lugar donde vas a dar a luz y preparar una mochila con ropa, documentos y artículos básicos.
🔸 Contar con una persona de apoyo, como tu pareja o familiar de confianza, para acompañarte.

Estar informada y rodeada de apoyo fortalece tu bienestar y el de tu bebé.
"""),
                _buildTabContent('Preeclampsia', """
La preeclampsia es una complicación del embarazo que se caracteriza por presión arterial alta y, en muchos casos, proteína en la orina. Suele aparecer después de la semana 20 de gestación y puede afectar tanto a la madre como al bebé, según la OMS y la OPS.

Los síntomas pueden incluir:

🔸 Dolor de cabeza intenso
🔸 Hinchazón en manos, rostro o pies
🔸 Visión borrosa o sensibilidad a la luz
🔸 Dolor en la parte alta del abdomen

Si no se trata a tiempo, la preeclampsia puede avanzar y poner en riesgo la vida de la madre y del bebé. Por eso, los controles prenatales regulares son clave para detectarla temprano.

El tratamiento depende de la gravedad. En casos leves se controla con reposo y medicamentos; en los graves, puede ser necesario adelantar el parto.

Estar informada y atenta a los síntomas puede salvar vidas.
"""),
                _buildTabContent('Riesgos en el embarazo', """
Aunque la mayoría de los embarazos transcurren sin problemas, algunos pueden presentar riesgos que afectan la salud de la madre o del bebé. La OMS y la OPS indican que reconocer estos riesgos a tiempo mejora las posibilidades de un parto seguro.

Factores de riesgo comunes incluyen:

🔸 Presión arterial alta o preeclampsia
🔸 Diabetes gestacional
🔸 Infecciones como VIH, sífilis o infecciones urinarias
🔸 Embarazo múltiple (gemelos o más)
🔸 Edad materna muy joven (menos de 18) o mayor de 35 años
🔸 Antecedentes de abortos o partos complicados

También pueden surgir riesgos si no se recibe control prenatal adecuado, si hay consumo de alcohol, tabaco o drogas, o si la nutrición es deficiente.

La mejor forma de prevenir complicaciones es con controles médicos regulares, buena alimentación, descanso y apoyo emocional. Tu salud y la de tu bebé son una prioridad.
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
