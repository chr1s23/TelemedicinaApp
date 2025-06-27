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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccione el mapa base',
          style: TextStyle(
            fontSize: 15, // Cambia este valor a lo que desees
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton<MapaBase>(
            value: _selectedMap,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMap = value;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: MapaBase.osm,
                child: Text('OpenStreetMap'),
              ),
              DropdownMenuItem(
                value: MapaBase.google,
                child: Text('Google Maps'),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _selectedMap == MapaBase.osm
          ? const MapsOSMScreen()
          : WIPScreen(),
    );
  }
}
