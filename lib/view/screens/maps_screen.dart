import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import '../../service/ubicacion_service.dart';
import '../../model/responses/ubicacion_response.dart';

class MapsScreen extends StatefulWidget {
  final String
      establecimiento; // Ej: 'CENTRO_SALUD', 'CENTRO_CONTRA_VIOLENCIA', 'CENTRO_ATENCION_PSICOLOGICA'

  const MapsScreen({super.key, required this.establecimiento});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<UbicacionResponse> ubicaciones = [];
  final PopupController _popupLayerController = PopupController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUbicaciones();
  }

  Future<void> _loadUbicaciones() async {
    try {
      final data = await UbicacionService.fetchUbicaciones(
          establecimiento: widget.establecimiento);
      setState(() {
        ubicaciones = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ubicaciones: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = ubicaciones.map((ubicacion) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(ubicacion.latitud, ubicacion.longitud),
        child: GestureDetector(
          onTap: () {
            _popupLayerController.togglePopup(Marker(
              width: 40,
              height: 40,
              point: LatLng(ubicacion.latitud, ubicacion.longitud),
              child: const Icon(Icons.location_on, size: 40, color: Colors.red),
            ));
          },
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleFromEstablecimiento(widget.establecimiento)),
      ),
      body: isLoading
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
                onTap: (_, __) => _popupLayerController.hideAllPopups(),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupLayerController,
                    markers: markers,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        final ubicacion = ubicaciones.firstWhere(
                          (u) =>
                              u.latitud == marker.point.latitude &&
                              u.longitud == marker.point.longitude,
                        );

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ubicacion.nombre,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Dirección: ${ubicacion.direccion}'),
                                    const SizedBox(height: 4),
                                    Text('Teléfono: ${ubicacion.telefono}'),
                                    const SizedBox(height: 4),
                                    Text('Horario: ${ubicacion.horario}'),
                                    const SizedBox(height: 4),
                                    Text('Sitio web: ${ubicacion.sitioWeb}'),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _popupLayerController.hideAllPopups();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
    );
  }

  LatLng _getInitialCenter() {
    // Puedes personalizar el centro según la ciudad o región
    return const LatLng(-2.9, -79.0); // uenca
  }

  String _getTitleFromEstablecimiento(String establecimiento) {
    switch (establecimiento) {
      case 'CENTRO_SALUD':
        return 'Centros de Salud';
      case 'CENTRO_CONTRA_VIOLENCIA':
        return 'Centros en contra de la Violencia';
      case 'CENTRO_ATENCION_PSICOLOGICA':
        return 'Centros de Atención Psicológica';
      default:
        return 'Mapa';
    }
  }
}
