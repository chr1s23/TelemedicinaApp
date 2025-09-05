import 'package:flutter/material.dart';

class BlogHigieneIntimaPage extends StatefulWidget {
  const BlogHigieneIntimaPage({super.key});

  @override
  State<BlogHigieneIntimaPage> createState() => _BlogHigieneIntimaPageState();
}

class _BlogHigieneIntimaPageState extends State<BlogHigieneIntimaPage> with SingleTickerProviderStateMixin {
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
        title: const Text("Higiene Íntima", style: TextStyle(color: Colors.white)),
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
            Tab(text: 'Importancia'),
            Tab(text: 'Frecuencia'),
            Tab(text: 'Autocuidado'),
            Tab(text: 'Ropa recomendada'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/higiene.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('¿Qué es la higiene íntima?', """
La higiene íntima es el conjunto de cuidados y hábitos diarios que ayudan a mantener limpia, saludable y protegida la zona genital. Según la OMS y la OPS, una buena higiene íntima es esencial para prevenir infecciones, malestares y alteraciones en el equilibrio natural de la flora vaginal.

Este tipo de cuidado no se trata solo de limpieza, sino de hacerlo de forma adecuada, sin productos agresivos ni prácticas innecesarias. El uso excesivo de jabones fuertes, duchas vaginales o desodorantes íntimos puede alterar el pH natural y favorecer infecciones.

Una higiene correcta ayuda a mantener el confort, prevenir malos olores, evitar irritaciones y promover el bienestar general, especialmente durante la menstruación, relaciones sexuales o después del parto.

Cuidar tu zona íntima es parte fundamental de tu salud sexual y tu autoestima.
"""),
                _buildTabContent('Importancia de la higiene íntima', """
La higiene íntima es esencial para mantener la salud de la zona genital y prevenir infecciones. Según la OMS y la OPS, una higiene adecuada ayuda a conservar el equilibrio natural de la flora vaginal y evita molestias como irritación, picazón o mal olor.

Cuando no se cuida correctamente esta área, aumenta el riesgo de infecciones como vaginosis, hongos o infecciones urinarias. También puede afectar el bienestar emocional y la vida sexual.

Mantener buenos hábitos de higiene íntima es importante en distintas etapas: durante la menstruación, el embarazo, después del parto o al tener relaciones sexuales. Además, favorece la autoexploración, lo que permite identificar cambios anormales a tiempo.

Cuidar tu zona íntima no es solo una cuestión de limpieza, sino un acto de respeto y amor propio. Es una parte fundamental del autocuidado y la salud general de cada persona.
"""),
                _buildTabContent('¿Con qué frecuencia debo hacerme la higiene íntima?', """
La higiene íntima debe realizarse todos los días, pero de forma suave y respetuosa con el cuerpo. Según la OMS y la OPS, limpiar la zona genital una vez al día con agua tibia y, si se desea, con un jabón neutro y sin perfume, es suficiente para mantener el equilibrio natural.

Durante ciertas etapas como la menstruación, después de tener relaciones sexuales, hacer ejercicio o sudar mucho, se recomienda lavar la zona dos veces al día, siempre sin exagerar. El exceso de limpieza o el uso de productos agresivos puede alterar el pH y provocar irritación o infecciones.

También es importante secar bien la zona, usar ropa interior de algodón y cambiarla a diario.

La clave está en mantener una rutina regular, sin exageraciones, que cuide tu salud sin alterar la flora natural de tu cuerpo.
"""),
                _buildTabContent('Autocuidado en la higiene íntima', """

El autocuidado íntimo es una parte importante de tu bienestar general. Más que limpiar, se trata de tener hábitos saludables que respeten tu cuerpo y eviten infecciones o molestias. Según la OMS y la OPS, estos son algunos cuidados clave:

🔸 Lava tu zona genital una o dos veces al día con agua y, si usas jabón, que sea neutro y sin perfume.
🔸 Evita las duchas vaginales, ya que alteran la flora natural.
🔸 Seca bien la zona íntima después del baño, de adelante hacia atrás.
🔸 Usa ropa interior de algodón y cámbiala a diario.
🔸 Durante la menstruación, cambia toallas o tampones cada 4 a 6 horas.
🔸 Evita productos como desodorantes íntimos o talcos.

Escuchar tu cuerpo, observar cambios y mantener hábitos sencillos es una forma de autocuidado y amor propio.
"""),
                _buildTabContent('¿Qué tipo de ropa ayuda a una buena higiene íntima?', """
La ropa que usas también influye en tu salud íntima. Según la OMS y la OPS, elegir prendas adecuadas ayuda a mantener la zona genital fresca, seca y libre de irritaciones o infecciones.

🔸 Usa ropa interior de algodón: El algodón es un material transpirable que absorbe la humedad y permite que la piel respire. Evita telas sintéticas como lycra o encajes que pueden retener calor y favorecer el crecimiento de bacterias u hongos.

🔸 Evita prendas muy ajustadas: Pantalones apretados o ropa interior demasiado ceñida pueden generar fricción, sudor y calor excesivo, lo que altera el equilibrio de la flora vaginal.

🔸 Cámbiala todos los días: Es importante cambiar la ropa interior diariamente (o más si sudas mucho o estás menstruando) para mantener la zona limpia y seca.

La elección de tu ropa también es parte del autocuidado. Comodidad y salud van de la mano.
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
