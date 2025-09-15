import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({super.key, required PlaceLocation? pickedLocation})
    : _pickedLocation = pickedLocation;

  final PlaceLocation? _pickedLocation;

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant MyLocation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔹 Move map center whenever pickedLocation changes
    if (widget._pickedLocation != null &&
        oldWidget._pickedLocation != widget._pickedLocation) {
      _mapController.move(
        LatLng(
          widget._pickedLocation!.latitude,
          widget._pickedLocation!.longitude,
        ),
        15, // zoom level
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(
          widget._pickedLocation!.latitude,
          widget._pickedLocation!.longitude,
        ),
        initialZoom: 15,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(LatLng(-85.0, -180.0), LatLng(85.0, 180.0)),
        ),
        interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.favorite_places',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              alignment: Alignment.center,
              point: LatLng(
                widget._pickedLocation!.latitude,
                widget._pickedLocation!.longitude,
              ),
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
