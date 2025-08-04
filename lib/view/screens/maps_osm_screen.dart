import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import '../../service/ubicacion_service.dart';
import '../../model/responses/ubicacion_response.dart';

class MapsOSMScreen extends StatefulWidget {
  const MapsOSMScreen({super.key});

  @override
  State<MapsOSMScreen> createState() => _MapsOSMScreenState();
}

class _MapsOSMScreenState extends State<MapsOSMScreen> {
  String selectedEstablecimiento = 'CENTRO_SALUD';
  List<UbicacionResponse> ubicaciones = [];
  bool isLoading = true;
  LatLng? _userLocation;
  final Map<String, List<UbicacionResponse>> _ubicacionesPorTipo = {};

  @override
  void initState() {
    super.initState();
    _loadUbicaciones();
  }

  Future<void> _loadUbicaciones() async {
    setState(() => isLoading = true);
    try {
      if (_ubicacionesPorTipo.containsKey(selectedEstablecimiento)) {
        setState(() {
          ubicaciones = _ubicacionesPorTipo[selectedEstablecimiento]!;
          isLoading = false;
        });
      } else {
        final data = await UbicacionService.fetchUbicaciones(
          establecimiento: selectedEstablecimiento,
        );
        if (!mounted) return;
        _ubicacionesPorTipo[selectedEstablecimiento] = data;
        setState(() {
          ubicaciones = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar('Error al cargar ubicaciones: $e');
    }
  }

  void _showSnackBar(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _showUbicacionDialog(UbicacionResponse ubicacion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(ubicacion.nombre),
          content: _buildUbicacionInfo(ubicacion),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUbicacionInfo(UbicacionResponse ubicacion) {
    final sitioWeb =
        ubicacion.sitioWeb.trim().replaceAll('\n', '').replaceAll('\r', '');
    final Uri urlSitio = Uri.parse(sitioWeb);
    final Uri telUri = Uri(scheme: 'tel', path: ubicacion.telefono.trim());

    return Column(
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
                    if (await canLaunchUrl(telUri)) {
                      await launchUrl(telUri);
                    } else {
                      _showSnackBar('No se pudo abrir la app de llamadas');
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
            if (await canLaunchUrl(urlSitio)) {
              await launchUrl(urlSitio);
            } else {
              _showSnackBar('No se pudo abrir el sitio web');
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
    );
  }

  List<Marker> _buildMarkers() {
    return ubicaciones.map((ubicacion) {
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(ubicacion.latitud, ubicacion.longitud),
        child: GestureDetector(
          onTap: () => _showUbicacionDialog(ubicacion),
          child: const Icon(Icons.location_on, size: 40, color: Color(0xFFA51008)),
        ),
      );
    }).toList();
  }

  LatLng _getInitialCenter() {
    return _userLocation ?? const LatLng(-2.9, -79.0);
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = selectedEstablecimiento == value;
    return ElevatedButton(
      onPressed: () {
        if (!isSelected) {
          setState(() => selectedEstablecimiento = value);
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

  Widget _buildFilterButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6.0,
      runSpacing: 4.0,
      children: [
        _buildFilterButton('CENTRO_SALUD', 'Ginecología'),
        _buildFilterButton('CENTRO_PROTECCION', 'En caso de agresión'),
        _buildFilterButton('ATENCION_PSICOLOGICA', 'Psicología'),
      ],
    );
  }

  Widget _buildStaticMap() {
    return FlutterMap(
      key: const PageStorageKey('flutter_map_osm'),
      options: MapOptions(
        initialCenter: _getInitialCenter(),
        initialZoom: 13.0,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.drag |
              InteractiveFlag.pinchZoom |
              InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.chatbot'
        ),
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(child: _buildFilterButtons()),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildStaticMap(), // Mapa no se reconstruye
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
