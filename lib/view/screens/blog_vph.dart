import 'package:flutter/material.dart';

class BlogVPHPage extends StatefulWidget {
  const BlogVPHPage({super.key});

  @override
  State<BlogVPHPage> createState() => _BlogVPHPageState();
}

class _BlogVPHPageState extends State<BlogVPHPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Virus del Papiloma Humano (VPH)", style: TextStyle(color: Colors.white)),  
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
            Tab(text: '¿Qué es el VPH?'),
            Tab(text: 'Transmisión del VPH'),
            Tab(text: 'Tipos de VPH'),
            Tab(text: 'Síntomas del VPH'),
            Tab(text: 'Tratamiento y Vacunas'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/VPH.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es el VPH?', """
El Virus del Papiloma Humano, conocido como VPH, es una infección muy común que se transmite principalmente por contacto sexual. Existen más de 100 tipos de VPH. Algunos causan verrugas en la piel o en los genitales, y otros pueden provocar cáncer, como el de cuello uterino, uno de los más frecuentes en mujeres según la OMS.

La mayoría de las personas con VPH no presentan síntomas y eliminan el virus sin tratamiento. Sin embargo, cuando no se detecta a tiempo, puede causar problemas graves de salud.

La OPS y la OMS recomiendan la vacuna contra el VPH para niñas y niños desde los 9 años, ya que protege contra los tipos del virus que más riesgo tienen de causar cáncer. También es clave realizar chequeos médicos regulares para prevenir complicaciones.
"""),
                _buildTabContent('Transmisión del VPH', """
El Virus del Papiloma Humano (VPH) se transmite principalmente a través del contacto sexual, incluyendo relaciones vaginales, anales u orales, incluso sin penetración. Según la OMS, es tan común que casi todas las personas sexualmente activas lo contraerán en algún momento de su vida.

El VPH también puede transmitirse por contacto piel con piel en las zonas genitales. No es necesario que haya eyaculación para que ocurra el contagio. En casos poco comunes, una madre infectada puede transmitir el virus a su bebé durante el parto.

La mayoría de las personas infectadas no saben que tienen el virus, ya que generalmente no presenta síntomas. Por eso, es muy difícil evitar su propagación solo con medidas visibles.

Usar preservativo reduce el riesgo, pero no lo elimina por completo. La mejor forma de prevención sigue siendo la vacunación temprana y los controles médicos regulares, tal como recomienda la OPS.
"""),
                _buildTabContent('Tipos de VPH', """
Existen más de 100 tipos de Virus del Papiloma Humano (VPH), pero no todos causan los mismos efectos. La OMS y la OPS los dividen en dos grupos principales: de bajo riesgo y de alto riesgo.

Los tipos de bajo riesgo, como el VPH 6 y 11, pueden causar verrugas en la piel o en los genitales, pero no suelen producir cáncer.

Los tipos de alto riesgo, como el VPH 16 y 18, están relacionados con varios tipos de cáncer, especialmente el de cuello uterino. También pueden causar cáncer de ano, pene, vagina, vulva y garganta.

La mayoría de las infecciones por VPH desaparecen solas, pero algunas persisten y pueden causar enfermedades graves con el tiempo. Por eso, la vacunación y los controles médicos son esenciales para prevenir sus consecuencias más peligrosas.
"""),
                _buildTabContent('Síntomas del VPH', """
La mayoría de las personas con Virus del Papiloma Humano (VPH) no presenta síntomas. Por eso, muchas veces la infección pasa desapercibida y se detecta solo con exámenes médicos de rutina, como la citología o prueba de VPH.

Cuando hay síntomas, pueden aparecer verrugas genitales, que son pequeños bultos en la zona íntima, alrededor del ano o en la boca. Estas suelen estar causadas por tipos de VPH de bajo riesgo.

Los tipos de alto riesgo, como el VPH 16 y 18, no causan síntomas visibles, pero pueden provocar cambios en las células que, con el tiempo, llevan al desarrollo de cáncer, especialmente de cuello uterino.

Por eso, la OPS y la OMS insisten en la importancia de los chequeos periódicos y la vacunación preventiva, ya que el VPH puede estar presente sin que la persona lo sepa.
"""),
                _buildTabContent('Tratamiento y Vacunas', """
Actualmente, no existe un tratamiento que elimine el VPH como virus, pero sí se pueden tratar las enfermedades que causa. Por ejemplo, las verrugas genitales pueden eliminarse con cremas, cirugía menor o láser. En el caso de lesiones precancerosas, como las del cuello uterino, se pueden tratar antes de que evolucionen a cáncer.

La mejor herramienta contra el VPH es la vacuna. Según la OMS y la OPS, esta es segura y altamente eficaz, especialmente contra los tipos 16 y 18, que causan la mayoría de los cánceres relacionados con el VPH.

Se recomienda vacunar a niñas y niños entre 9 y 14 años, antes del inicio de la vida sexual. Aunque no sustituye los chequeos médicos, la vacuna ayuda a reducir significativamente el riesgo de complicaciones graves.

La prevención, a través de la vacunación y exámenes periódicos, es la clave para controlar esta infección.
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
