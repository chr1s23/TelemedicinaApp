import 'package:flutter/material.dart';

class BlogSaludSexualPage extends StatefulWidget {
  const BlogSaludSexualPage({super.key});

  @override
  State<BlogSaludSexualPage> createState() => _BlogSaludSexualPageState();
}

class _BlogSaludSexualPageState extends State<BlogSaludSexualPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Salud Sexual", style: TextStyle(color: Colors.white)), 
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
            Tab(text: '¿Qué es la salud sexual?'),
            Tab(text: 'La primera vez'),
            Tab(text: 'Autocuidado en salud sexual'),
            Tab(text: 'Servicios de salud sexual'),
            Tab(text: 'Consentimiento'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/salud_sexual.png'), 
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                "Salud Sexual",
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
                _buildTabContent('¿Qué es la salud sexual?', """
La salud sexual es un estado de bienestar físico, emocional, mental y social relacionado con la sexualidad. Según la OMS, no se trata solo de la ausencia de enfermedades, sino de poder vivir la sexualidad de forma segura, placentera, libre de violencia y con derechos respetados.

La salud sexual incluye el derecho a:

🔸 Decidir sobre tu cuerpo y tus relaciones sin presión ni miedo.
🔸 Acceder a información clara y servicios de salud de calidad.
🔸 Elegir si tener hijos, cuándo y con quién.

Prevenir infecciones, embarazos no deseados y vivir sin discriminación.
"""),
                _buildTabContent('La primera vez', """
Tener relaciones sexuales por primera vez es una experiencia importante que debe vivirse de forma libre, segura y consciente. Según la OMS y la OPS, la salud sexual implica poder decidir cuándo, con quién y cómo vivir tu sexualidad, sin presiones ni miedo.

Lo importante es:

🔸 Sentirte emocional y físicamente preparado(a)
🔸 Tener información clara sobre métodos anticonceptivos y prevención de ITS
🔸 Contar con una pareja que respete tus decisiones y tus límites
"""),
                _buildTabContent('Autocuidado en salud sexual', """
El autocuidado sexual es una parte importante de tu salud y bienestar. Significa tomar decisiones informadas, respetar tu cuerpo y prevenir situaciones que puedan poner en riesgo tu salud física y emocional.

Algunas acciones clave de autocuidado son:

🔸 Conocer tu cuerpo y cómo se siente cuando está sano.
🔸 Usar condón en todas las relaciones sexuales para prevenir ITS y embarazos no planificados.
🔸 Hacerte chequeos médicos periódicos, incluyendo pruebas de ITS.
🔸 Vacunarte contra el VPH y la hepatitis B si está disponible.
"""),
                _buildTabContent('Servicios de salud sexual', """
Los servicios de salud sexual son espacios donde puedes recibir atención médica, orientación y apoyo para vivir tu sexualidad de forma segura y saludable. 
Según la OMS y la OPS, estos servicios deben ser gratuitos o accesibles, confidenciales y sin discriminación.

¿Qué ofrecen?

🔸 Acceso a métodos anticonceptivos
🔸 Pruebas y tratamiento de ITS, incluyendo VIH
🔸 Atención en salud sexual para adolescentes y población LGBTIQ+
🔸 Consejería sobre relaciones, consentimiento y embarazo
🔸 Apoyo en casos de violencia sexual o de género
"""),
                _buildTabContent('Consentimiento', """
El consentimiento significa decir sí con libertad, claridad y seguridad. Según la OMS y la OPS, es un elemento fundamental en toda relación sexual: debe ser mutuo, informado, voluntario y reversible.

Esto quiere decir que:

🔸 Debe darse sin presión, miedo ni manipulación.
🔸 Puedes cambiar de opinión en cualquier momento, incluso si ya habías dicho que sí.
🔸 El silencio o no decir “no” no es lo mismo que consentir.
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
