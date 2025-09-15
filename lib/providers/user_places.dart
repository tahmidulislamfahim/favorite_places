import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import '../models/place.dart';
import '../models/place_hive.dart';

class UserPlacesNotifier extends Notifier<List<Place>> {
  late Box<PlaceHive> _placesBox;

  @override
  List<Place> build() {
    _placesBox = Hive.box<PlaceHive>('places');
    // Load saved places from Hive
    final places = _placesBox.values.map((placeHive) {
      return Place(
        id: placeHive.id,
        title: placeHive.title,
        image: File(placeHive.imagePath),
        location: PlaceLocation(
          latitude: placeHive.location.latitude,
          longitude: placeHive.location.longitude,
          address: placeHive.location.address,
        ),
      );
    }).toList();

    return places;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$fileName');

    final updatedPlace = Place(
      id: place.id,
      title: place.title,
      location: place.location,
      image: copiedImage,
    );

    state = [updatedPlace, ...state];

    // Save to Hive
    final placeHive = PlaceHive(
      id: updatedPlace.id,
      title: updatedPlace.title,
      imagePath: copiedImage.path,
      location: PlaceLocationHive(
        latitude: updatedPlace.location.latitude,
        longitude: updatedPlace.location.longitude,
        address: updatedPlace.location.address,
      ),
    );

    await _placesBox.put(updatedPlace.id, placeHive);
  }

  void deletePlace(String id) async {
    // Remove from Hive
    await _placesBox.delete(id);

    // Remove from state
    state = state.where((place) => place.id != id).toList();
  }
}

final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  () => UserPlacesNotifier(),
);
