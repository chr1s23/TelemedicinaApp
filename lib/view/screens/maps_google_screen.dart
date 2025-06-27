import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../service/ubicacion_service.dart';
import '../../model/responses/ubicacion_response.dart';

class MapsGoogleScreen extends StatefulWidget {
  const MapsGoogleScreen({super.key});

  @override
  State<MapsGoogleScreen> createState() => _MapsGoogleScreenState();
}

class _MapsGoogleScreenState extends State<MapsGoogleScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String selectedEstablecimiento = 'CENTRO_SALUD';
  List<UbicacionResponse> ubicaciones = [];
  bool isLoading = true;
  static const LatLng _defaultCenter = LatLng(-2.9, -79.0);

  @override
  void initState() {
    super.initState();
    _loadUbicaciones();
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

  Set<Marker> _createMarkers() {
    return ubicaciones.map((ubicacion) {
      return Marker(
        markerId: MarkerId(ubicacion.nombre),
        position: LatLng(ubicacion.latitud, ubicacion.longitud),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: ubicacion.telefono,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri telUri = Uri(
                                  scheme: 'tel',
                                  path: ubicacion.telefono.trim());
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
                              content: Text('No se pudo abrir el sitio web')),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Localización de Servicios Relacionados',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 6.0,
                runSpacing: 4.0,
                children: [
                  _buildFilterButton('CENTRO_SALUD', 'Ginecología'),
                  _buildFilterButton('CENTRO_PROTECCION', 'En caso de agresión'),
                  _buildFilterButton('ATENCION_PSICOLOGICA', 'Psicología'),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _defaultCenter,
                      zoom: 13,
                    ),
                    markers: _createMarkers(),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = selectedEstablecimiento == value;
    return ElevatedButton(
      onPressed: () {
        if (!isSelected) {
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
        maxLines: 2,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
