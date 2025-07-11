import 'package:flutter/material.dart';

class BlogPrevencionEmbarazoPage extends StatefulWidget {
  const BlogPrevencionEmbarazoPage({super.key});

  @override
  State<BlogPrevencionEmbarazoPage> createState() => _BlogPrevencionEmbarazoPageState();
}

class _BlogPrevencionEmbarazoPageState extends State<BlogPrevencionEmbarazoPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Prevención de Embarazo", style: TextStyle(color: Colors.white)), 
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
            Tab(text: 'Métodos anticonceptivos'),
            Tab(text: 'Control prenatal'),
            Tab(text: 'Efectividad de métodos'),
            Tab(text: '¿Dónde conseguir anticonceptivos?'),
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
            child: Center(
              child: Text(
                "Concepto y Prevención",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('Métodos anticonceptivos', """
Los métodos anticonceptivos son formas de prevenir embarazos no deseados, y en algunos casos también protegen contra infecciones de transmisión sexual (ITS), como el VPH y el VIH. 

Según la OMS y la OPS, existen varios tipos que se adaptan a las necesidades de cada persona:

🔸 Métodos hormonales: pastillas, inyecciones, implantes, parches o anillos vaginales. Regulan las hormonas para evitar la ovulación.

🔸 Métodos de barrera: condones masculinos o femeninos. Evitan que el esperma llegue al óvulo y también protegen contra ITS.

🔸 Dispositivos intrauterinos (DIU): de cobre o con hormonas. Se colocan en el útero y tienen alta efectividad por varios años.

🔸 Métodos permanentes: como la ligadura de trompas o la vasectomía.

🔸 Métodos naturales y de emergencia: seguimiento del ciclo o píldora del día después.

Elegir el método correcto depende de factores como la edad, salud, frecuencia sexual y deseo de tener hijos en el futuro.
"""),
                _buildTabContent('Control prenatal', """
El control prenatal es el seguimiento médico que recibe una mujer durante el embarazo para asegurar la salud de la madre y del bebé. Según la OMS y la OPS, es fundamental para detectar a tiempo cualquier problema que pueda afectar el embarazo.

Durante las visitas prenatales, se realizan exámenes físicos, ecografías, análisis de sangre y orina, y se da orientación sobre alimentación, vacunas y preparación para el parto. También se identifican factores de riesgo como presión alta, diabetes gestacional o infecciones.

La OMS recomienda al menos ocho consultas prenatales, iniciando idealmente en el primer trimestre. Un buen control prenatal reduce las complicaciones, mejora el desarrollo del bebé y permite un parto más seguro.
"""),
                _buildTabContent('Efectividad de métodos', """
La efectividad anticonceptiva indica qué tan bien un método previene el embarazo. Según la OMS y la OPS, algunos métodos son más seguros que otros, especialmente si se usan correctamente y de forma constante.

🔸 Muy efectivos (más del 99%): implantes, dispositivos intrauterinos (DIU) y esterilización quirúrgica. Son de larga duración y no dependen del uso diario.

🔸 Altamente efectivos (91-99%): pastillas, inyecciones, parches y anillos vaginales. Funcionan bien si se usan exactamente como se indica.

🔸 Efectivos (82-88%): condón masculino o femenino. Su eficacia mejora si se usa correctamente en cada relación.

🔸 Menos efectivos: métodos naturales, como el ritmo o la temperatura basal, y espermicidas.

La elección depende de cada persona, pero lo más importante es usar el método correctamente y consultar al personal de salud para encontrar el más adecuado.
"""),
                _buildTabContent('¿Dónde conseguir anticonceptivos?', """
En Cuenca, puedes acceder a métodos anticonceptivos de forma gratuita en centros públicos o comprarlos en farmacias privadas. Aquí te explicamos dónde:

🏥 Puntos públicos (gratuitos)
Sala de Salud Sexual y Reproductiva – Alcaldía de Cuenca
Ofrece implantes anticonceptivos, inyecciones, consejería y colocación de métodos de larga duración.
📍 Dirección: Av. 12 de Abril y Florencia Astudillo (Hospital Universitario)
📞 Teléfono: 07 284 5675

Centros de Salud del Ministerio de Salud Pública (MSP)
Entregan pastillas, inyecciones, condones y DIU sin costo.
📍 Ejemplos:
🔸Centro de Salud El Vecino
🔸Centro de Salud Carlos Elizalde
🔸Centro de Salud N° 3 (Zona El Paraíso)

Puedes ubicar el más cercano en: www.salud.gob.ec

💊 Farmacias privadas
Puedes comprar métodos como condones, pastillas, inyecciones y tests de embarazo en cadenas como:
Pharmacys Cuenca
🔸Farmacias Cruz Azul
🔸Fybeca
🔸Farmacias Sinai
🔸Farmacias Comunitarias (Farmashop Municipal)
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
            ),
          ],
        ),
      ),
    );
  }
}
