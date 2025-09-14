import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData? _pickedLocation;
  var _isGettingLocation = false;

  Future<void> _getCurrentLocation() async {
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    final locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
      _pickedLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            _pickedLocation!.latitude!,
            _pickedLocation!.longitude!,
          ),
          initialZoom: 15,
          minZoom: 1,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags:
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.drag,
          ),
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(LatLng(-85.0, -180.0), LatLng(85.0, 180.0)),
          ),
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
                  _pickedLocation!.latitude!,
                  _pickedLocation!.longitude!,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Add map selection
              },
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
