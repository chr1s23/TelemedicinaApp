import 'package:flutter/material.dart';
import 'maps_osm_screen.dart';
import 'wip.dart';

enum MapaBase { osm, google }

class MapsSelectorScreen extends StatefulWidget {
  const MapsSelectorScreen({super.key});

  @override
  State<MapsSelectorScreen> createState() => _MapsSelectorScreenState();
}

class _MapsSelectorScreenState extends State<MapsSelectorScreen> {
  MapaBase _selectedMap = MapaBase.osm;

  void _toggleMapa() {
    setState(() {
      _selectedMap =
          _selectedMap == MapaBase.osm ? MapaBase.google : MapaBase.osm;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget mapa = _selectedMap == MapaBase.osm
        ? const MapsOSMScreen()
        : const WIPScreen();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: mapa), // Asegura que el mapa se expanda
          Positioned(
            bottom: 110, // más bajo = más cerca del borde inferior
            left: 15,  // más grande = más hacia el centro
            child: FloatingActionButton(
              heroTag: 'cambiar_mapa',
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF002856),
              tooltip: _selectedMap == MapaBase.osm
                  ? 'Cambiar a Google Maps'
                  : 'Cambiar a OpenStreetMap',
              onPressed: _toggleMapa,
              child: Icon(
                _selectedMap == MapaBase.osm ? Icons.picture_in_picture_alt_outlined : Icons.picture_in_picture_alt,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
