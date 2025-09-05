import 'package:flutter/material.dart';

class BlogItsPage extends StatefulWidget {
  const BlogItsPage({super.key});

  @override
  State<BlogItsPage> createState() => _BlogItsPageState();
}

class _BlogItsPageState extends State<BlogItsPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Infección de Transmisión Sexual", style: TextStyle(color: Colors.white)),
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
            Tab(text: '¿Qué son las ITS?'),
            Tab(text: 'Tipos de ITS'),
            Tab(text: 'Síntomas'),
            Tab(text: 'Prevención'),
            Tab(text: 'Consecuencias'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ITS.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué son las ITS?', """
Las infecciones de transmisión sexual (ITS), anteriormente llamadas enfermedades de transmisión sexual (ETS), son enfermedades causadas por virus, bacterias o parásitos que se transmiten principalmente por contacto sexual, incluyendo relaciones vaginales, anales u orales sin protección.

Según la OMS, las ITS más comunes incluyen clamidia, gonorrea, sífilis, herpes, VIH y el virus del papiloma humano (VPH). Muchas de estas infecciones pueden no presentar síntomas al inicio, pero si no se tratan a tiempo, pueden causar complicaciones graves como infertilidad, cáncer o transmisión al bebé durante el parto.

Las ITS afectan a personas de cualquier edad o género, y el riesgo aumenta si no se usa protección o si no se realiza control médico.

Detectarlas a tiempo y prevenirlas es clave para cuidar tu salud sexual.
"""),
                _buildTabContent('Tipos de ITS', """
Las ITS pueden ser causadas por virus, bacterias o parásitos, y algunas son más comunes que otras. Según la OMS, estos son los principales tipos:

ITS virales:

🔸 VIH: debilita el sistema inmunológico y puede llevar al SIDA.
🔸 Virus del Papiloma Humano (VPH): puede causar verrugas genitales y algunos tipos de cáncer.
🔸 Herpes genital (VHS-1 y VHS-2): provoca llagas dolorosas alrededor de los genitales.
🔸 Hepatitis B: afecta al hígado y se transmite por sangre y relaciones sexuales.

ITS bacterianas:

🔸 Clamidia: puede causar infertilidad si no se trata.
🔸 Gonorrea: afecta el aparato reproductor y puede pasar al bebé en el parto.
🔸 Sífilis: comienza con una llaga indolora y puede avanzar a etapas graves si no se trata.

ITS parasitarias:

🔸 Tricomoniasis: causa flujo vaginal con mal olor, picazón o ardor.
🔸 Piojos púbicos ("ladillas") y sarna: parásitos que se transmiten por contacto cercano.
"""),
                _buildTabContent('Síntomas', """
Muchas infecciones de transmisión sexual (ITS) pueden no causar síntomas al inicio, lo que hace que pasen desapercibidas. Sin embargo, según la OMS y la OPS, cuando aparecen, los síntomas más comunes incluyen:

🔸 Flujo vaginal o secreción genital anormal
🔸 Dolor o ardor al orinar
🔸 Llagas, ampollas o verrugas en los genitales, ano o boca
🔸 Picazón o enrojecimiento en la zona íntima
🔸 Dolor durante las relaciones sexuales
🔸 Inflamación en los ganglios (cuello, ingles)
🔸 Fiebre o malestar general (en algunos casos)
"""),
                _buildTabContent('Prevención', """
Prevenir las infecciones de transmisión sexual (ITS) es posible si tomas medidas de cuidado y protección. Según la OMS y la OPS, estas son las formas más efectivas:

🔸 Usar condón correctamente en todas las relaciones sexuales (vaginales, orales o anales).
🔸 Limitar el número de parejas sexuales y conocer su estado de salud.
🔸 Realizarse pruebas periódicas de ITS, incluso si no hay síntomas.
🔸 Evitar compartir agujas o jeringas.
🔸 Las personas con ITS deben recibir tratamiento adecuado para cortar la cadena de transmisión.
🔸 Vacunarse contra el VPH y la hepatitis B, si está disponible.
"""),
                _buildTabContent('Consecuencias', """
Si no se detectan y tratan a tiempo, las infecciones de transmisión sexual (ITS) pueden causar graves problemas de salud. Según la OMS y la OPS, estas son algunas de sus consecuencias más comunes:

🔸 Infertilidad, especialmente en mujeres, por daño en las trompas de Falopio.
🔸 Complicaciones en el embarazo, como partos prematuros, abortos o transmisión al bebé.
🔸 Mayor riesgo de contraer VIH, ya que algunas ITS dañan las mucosas y facilitan el ingreso del virus.
🔸 Cáncer, especialmente de cuello uterino (por VPH) y de hígado (por hepatitis B).
🔸 Daños neurológicos o cardíacos, en casos de sífilis avanzada.
🔸 Dolor crónico en la pelvis o al tener relaciones sexuales.
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
