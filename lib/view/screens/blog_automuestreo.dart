import 'package:flutter/material.dart';

class BlogAutomuestreoPage extends StatefulWidget {
  const BlogAutomuestreoPage({super.key});

  @override
  State<BlogAutomuestreoPage> createState() => _BlogAutomuestreoPageState();
}

class _BlogAutomuestreoPageState extends State<BlogAutomuestreoPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Automuestreo", style: TextStyle(color: Colors.white)),   
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
            Tab(text: '¿Qué es el automuestreo vaginal?'),
            Tab(text: 'Importancia'),
            Tab(text: 'Automuestreo vaginal vs. Papanicolaou'),
            Tab(text: 'Mitos'),
            Tab(text: 'Efectividad'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Automuestreo.png'), 
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                "",
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
                _buildTabContent('¿Qué es el automuestreo vaginal?', """
El automuestreo vaginal es una técnica sencilla en la que una mujer recoge una muestra de su propia zona íntima, usando un hisopo, para detectar infecciones como el Virus del Papiloma Humano (VPH). Según la OMS y la OPS, es una alternativa segura, confiable y menos invasiva al examen ginecológico tradicional.

Este método permite tomar la muestra en casa o en un centro de salud, sin la necesidad de un profesional en el momento. Es útil especialmente para mujeres que sienten vergüenza, miedo o barreras para acceder a un examen ginecológico.

Estudios científicos han demostrado que el automuestreo tiene una alta efectividad para detectar el VPH, ayudando a prevenir el cáncer de cuello uterino de forma oportuna.

Además, promueve el autocuidado y el acceso a la salud para más mujeres. Es una herramienta práctica y poderosa para salvar vidas.
"""),
                _buildTabContent('Importancia', """
El automuestreo vaginal es una herramienta clave para la detección temprana del Virus del Papiloma Humano (VPH), principal causa del cáncer de cuello uterino. Según la OMS y la OPS, este método es especialmente importante porque permite a más mujeres acceder al tamizaje, incluso si viven en zonas rurales o enfrentan barreras para ir al médico.

Además, estudios científicos han demostrado que el automuestreo es tan confiable como una prueba tomada por personal de salud, y muchas mujeres lo consideran más cómodo y privado.

Su importancia también radica en que fomenta el autocuidado y la prevención, lo que reduce el riesgo de complicaciones graves en el futuro. Al facilitar la toma de muestra en casa o en espacios seguros, se aumenta la cobertura de pruebas y se salvan vidas mediante diagnósticos más tempranos.

Detectar a tiempo el VPH puede marcar la diferencia entre un tratamiento simple y un cáncer avanzado.
"""),
                _buildTabContent('Automuestreo vaginal vs. Papanicolaou', """
Tanto el automuestreo vaginal como el Papanicolaou son métodos para detectar enfermedades del cuello uterino, especialmente el Virus del Papiloma Humano (VPH) y lesiones precancerosas. Pero tienen diferencias importantes.

El Papanicolaou se realiza en un centro de salud, con ayuda de un profesional que toma la muestra del cuello uterino usando un espéculo. Requiere cita médica, puede causar incomodidad y muchas mujeres evitan hacerlo por vergüenza o miedo.

El automuestreo vaginal, en cambio, permite que la propia mujer tome la muestra en casa o en un centro, de forma privada y sin instrumentos invasivos. Según la OMS, es una opción confiable para detectar VPH y aumentar el acceso al tamizaje.

Ambos métodos son válidos, pero el automuestreo facilita el acceso, sobre todo en zonas rurales o con poca atención médica. Lo importante es realizarse alguna prueba: detectar a tiempo salva vidas.
"""),
                _buildTabContent('Mitos', """
Aunque el automuestreo vaginal es una herramienta segura y eficaz para detectar el VPH, aún existen muchos mitos que generan miedo o desconfianza. Aclararlos es clave para que más mujeres se animen a cuidar su salud.

🔸 “No es confiable porque lo hago yo misma”
Falso. Estudios avalados por la OMS confirman que el automuestreo tiene alta precisión si se siguen las instrucciones correctamente.

🔸 “Puede hacerme daño”
No. El hisopo es suave y está diseñado para que cualquier mujer pueda usarlo sin lastimarse.

🔸 “Solo sirve si tengo síntomas”
Error. El automuestreo detecta el VPH incluso sin síntomas, lo que permite actuar a tiempo y prevenir el cáncer de cuello uterino.

🔸 “Es mejor ir al médico”
Ambos métodos son válidos. El automuestreo es una opción más cómoda y accesible, pero no sustituye el seguimiento médico si hay resultados anormales.

🔸 “Puede hacerme daño o va a doler”
No. El hisopo es suave, corto y está diseñado para ser usado sin causar dolor. La mayoría de mujeres dice que no sintió molestias.

🔸 “Se puede quedar adentro el hisopo”
Es muy poco probable. El hisopo tiene un mango largo que impide que se pierda. Además, no entra profundamente.
Informarse es el primer paso para cuidarte sin miedo.
"""),
                _buildTabContent('Efectividad', """
El automuestreo vaginal es una herramienta altamente efectiva para detectar el Virus del Papiloma Humano (VPH), el principal causante del cáncer de cuello uterino. Según estudios respaldados por la OMS y la OPS, esta técnica tiene una efectividad igual a la prueba tomada por un profesional de salud, si se realiza correctamente.

Además de su confiabilidad, ofrece otras ventajas clave: es menos invasiva, más cómoda, privada y puede hacerse en casa, lo que facilita el acceso al tamizaje en mujeres que por vergüenza, miedo o distancia no asisten a controles ginecológicos.

La evidencia científica ha demostrado que el automuestreo aumenta la participación en programas de detección del VPH, especialmente en zonas rurales o poblaciones con barreras de acceso.

Más pruebas significa más diagnósticos a tiempo. Y un diagnóstico temprano, salva vidas.
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
