import 'package:flutter/material.dart';

class BlogVIHPage extends StatefulWidget {
  const BlogVIHPage({super.key});

  @override
  State<BlogVIHPage> createState() => _BlogVIHPageState();
}

class _BlogVIHPageState extends State<BlogVIHPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Virus de Inmunodeficiencia Humana (VIH)", style: TextStyle(color: Colors.white)),
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
            Tab(text: '¿Qué es el VIH?'),
            Tab(text: 'Transmisión del VIH'),
            Tab(text: 'Prevención del VIH'),
            Tab(text: 'Pruebas de VIH'),
            Tab(text: 'Síntomas y tratamiento'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/VIH.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es el VIH?', """
El Virus de Inmunodeficiencia Humana (VIH) es un virus que ataca el sistema inmunológico, debilitando las defensas del cuerpo. Si no se trata, puede evolucionar al SIDA (síndrome de inmunodeficiencia adquirida), la etapa más avanzada de la infección, según la OMS.

El VIH se transmite por relaciones sexuales sin protección, contacto con sangre contaminada (como al compartir agujas) o de una madre a su hijo durante el embarazo, parto o lactancia, según indica la OPS. No se transmite por abrazos, besos, ni compartir alimentos o vasos.

Aunque no tiene cura, el VIH sí tiene tratamiento. Con los medicamentos llamados antirretrovirales, una persona con VIH puede vivir muchos años, con buena calidad de vida y sin transmitir el virus a otras personas.

Detectarlo a tiempo y seguir el tratamiento es esencial para controlar el virus y cuidar la salud.
"""),
                _buildTabContent('Transmisión del VIH', """
El VIH se transmite cuando ciertos fluidos corporales de una persona con el virus entran al cuerpo de otra. Según la OMS y la OPS, los fluidos que pueden transmitir el VIH son: sangre, semen, fluidos vaginales, rectales y leche materna.

Las formas más comunes de transmisión son:

🔸 Tener relaciones sexuales sin protección con una persona con VIH.
🔸 Compartir agujas o jeringas contaminadas.
🔸 De madre a hijo durante el embarazo, parto o lactancia si no se recibe tratamiento.

El VIH no se transmite por abrazar, besar, dar la mano, compartir platos o usar el mismo baño.

Gracias al tratamiento antirretroviral, una persona con VIH que mantiene su carga viral indetectable no transmite el virus por vía sexual, lo que se conoce como Indetectable = Intransmisible (I=I).
"""),
                _buildTabContent('Prevención del VIH', """
El VIH se puede prevenir con acciones simples y efectivas. La OMS y la OPS recomiendan varias medidas clave para reducir el riesgo de infección:

🔸 Usar condón correctamente en todas las relaciones sexuales.
🔸 Realizarse pruebas de VIH y conocer el estado serológico propio y de la pareja.
🔸 Tomar PrEP (profilaxis preexposición) si estás en alto riesgo; es un medicamento que ayuda a prevenir el VIH antes de exponerte.
🔸 No compartir agujas, jeringas ni objetos cortopunzantes.
🔸 Las personas con VIH deben seguir su tratamiento antirretroviral para mantener la carga viral indetectable, lo que evita la transmisión (I=I).
🔸 Las embarazadas con VIH deben recibir atención médica para evitar la transmisión al bebé durante el embarazo, parto o lactancia.

La prevención del VIH es posible y está al alcance de todos con educación, acceso a servicios de salud y decisiones informadas.
"""),
                _buildTabContent('Pruebas de VIH', """
Las pruebas de VIH permiten saber si una persona vive con el virus. Según la OMS y la OPS, hacerse la prueba es el primer paso para recibir tratamiento y proteger la salud propia y de los demás.

Existen distintos tipos de pruebas:

🔸 Rápidas, que dan resultados en 20 minutos con una gota de sangre o muestra de saliva.
🔸 De laboratorio, más detalladas y usadas para confirmar resultados.

Las pruebas son confidenciales, seguras y gratuitas en muchos centros de salud. Se recomienda hacerla si tuviste relaciones sexuales sin protección, compartiste agujas o estás embarazada.

Saber tu estado serológico te permite actuar a tiempo. Con tratamiento, el VIH se puede controlar y llevar una vida larga y saludable.
"""),
                _buildTabContent('Síntomas y tratamiento', """
Muchas personas con VIH no presentan síntomas al principio. Algunas pueden tener fiebre, dolor de garganta, fatiga o sarpullido poco después de la infección. Estos signos iniciales suelen desaparecer, pero el virus sigue activo y daña lentamente el sistema inmunológico.

Sin tratamiento, el VIH puede avanzar durante años sin síntomas visibles, hasta llegar a la etapa de SIDA, donde aparecen infecciones graves o ciertos tipos de cáncer.

El tratamiento actual es la terapia antirretroviral (TAR). Según la OMS y la OPS, este tratamiento no cura el VIH, pero controla el virus, protege el sistema inmunológico y permite una vida larga y saludable. Además, si la persona alcanza una carga viral indetectable, no transmite el virus por vía sexual (I=I).

Comenzar el tratamiento lo antes posible es clave para una mejor calidad de vida.
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
