import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_picker_screen.dart';
import 'package:favorite_places/widgets/my_location.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(double lat, double lng, String address) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  String? _address;

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

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }

    // 🔹 Convert to human readable address
    final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
    final place = placemarks.first;
    final readableAddress =
        "${place.street}, ${place.locality}, ${place.country}";

    setState(() {
      _isGettingLocation = false;
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: readableAddress,
      );
      _address = readableAddress;
    });

    widget.onSelectLocation(lat, lng, readableAddress);
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
      previewContent = Column(
        children: [
          SizedBox(
            height: 120,
            child: MyLocation(pickedLocation: _pickedLocation),
          ),
          if (_address != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _address!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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
              onPressed: () async {
                final pickedPoint = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(builder: (ctx) => const MapPickerScreen()),
                );

                if (pickedPoint == null) return;

                // 🔹 Convert to address
                final placemarks = await geocoding.placemarkFromCoordinates(
                  pickedPoint.latitude,
                  pickedPoint.longitude,
                );
                final place = placemarks.first;
                final readableAddress =
                    "${place.street}, ${place.locality}, ${place.country}";

                setState(() {
                  _pickedLocation = PlaceLocation(
                    latitude: pickedPoint.latitude,
                    longitude: pickedPoint.longitude,
                    address: readableAddress,
                  );
                  _address = readableAddress;
                });

                widget.onSelectLocation(
                  pickedPoint.latitude,
                  pickedPoint.longitude,
                  readableAddress,
                );
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
