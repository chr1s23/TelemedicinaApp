import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import '../../service/ubicacion_service.dart';
import '../../model/responses/ubicacion_response.dart';

class MapsUnifiedScreen extends StatefulWidget {
  const MapsUnifiedScreen({super.key});

  @override
  State<MapsUnifiedScreen> createState() => _MapsUnifiedScreenState();
}

class _MapsUnifiedScreenState extends State<MapsUnifiedScreen> {
  String selectedEstablecimiento = 'CENTRO_SALUD'; // Default inicial
  List<UbicacionResponse> ubicaciones = [];
  bool isLoading = true;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _loadUbicaciones(); // Carga inicial
  }

  Future<void> _loadUbicaciones() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await UbicacionService.fetchUbicaciones(
        establecimiento: selectedEstablecimiento,
      );

      if (!mounted) return;

      setState(() {
        ubicaciones = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ubicaciones: $e')),
      );
    }
  }

/*  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!mounted) return null;

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El GPS está deshabilitado. Por favor, actívelo.')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (!mounted) return null;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return null;
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permiso de ubicación denegado permanentemente')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _goToUserLocation() async {
    final position = await _determinePosition();
    if (position != null) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final markers = ubicaciones.map((ubicacion) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(ubicacion.latitud, ubicacion.longitud),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(ubicacion.nombre),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dirección: ${ubicacion.direccion}'),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: 'Teléfono: ',
                          style: DefaultTextStyle.of(context)
                              .style, // estilo por defecto
                          children: [
                            TextSpan(
                              text: ubicacion.telefono,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final telefono = ubicacion.telefono.trim();
                                  final Uri telUri =
                                      Uri(scheme: 'tel', path: telefono);

                                  if (await canLaunchUrl(telUri)) {
                                    await launchUrl(telUri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'No se pudo abrir la app de llamadas')),
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Horario: ${ubicacion.horario}'),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final sitioWeb = ubicacion.sitioWeb
                              .trim()
                              .replaceAll('\n', '')
                              .replaceAll('\r', '');
                          final Uri url = Uri.parse(sitioWeb);

                          if (await canLaunchUrl(url)) {
                            launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('No se pudo abrir el sitio web')),
                            );
                          }
                        },
                        child: Text(
                          ubicacion.sitioWeb,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: const Text(
            'Localización de Servicios Relacionados',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          // Fila de botones arriba del mapa → ahora es Wrap
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              // Esto centra el Wrap explícitamente
              child: Wrap(
                alignment: WrapAlignment
                    .center, // Alinea el contenido del Wrap en el centro
                spacing: 6.0, // espacio entre botones
                runSpacing: 4.0, // espacio entre filas
                children: [
                  _buildFilterButton('CENTRO_SALUD', 'Ginecología'),
                  _buildFilterButton(
                      'CENTRO_PROTECCION', 'En caso de agresión'),
                  _buildFilterButton('ATENCION_PSICOLOGICA', 'Psicología'),
                ],
              ),
            ),
          ),
          // Mapa
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: _getInitialCenter(),
                      initialZoom: 13.0,
                      initialRotation: 0.0,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.drag |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                      MarkerLayer(markers: markers),
                    ],
                  ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _goToUserLocation,
        tooltip: 'Ir a mi ubicación',
        child: const Icon(Icons.my_location),
      ),*/
    );
  }

  LatLng _getInitialCenter() {
    if (_userLocation != null) {
      return _userLocation!;
    }
    return const LatLng(-2.9, -79.0);
  }

  // Widget para cada botón de filtro → con texto adaptable
  Widget _buildFilterButton(String value, String label) {
    final isSelected = selectedEstablecimiento == value;
    return ElevatedButton(
      onPressed: () {
        if (selectedEstablecimiento != value) {
          setState(() {
            selectedEstablecimiento = value;
          });
          _loadUbicaciones();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFF002856) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: 2, // por si es muy largo el texto
        style:
            const TextStyle(fontSize: 12), // tamaño amigable en todas pantallas
      ),
    );
  }
}
