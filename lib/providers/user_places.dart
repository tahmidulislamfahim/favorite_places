import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => [];

  void addPlace(Place place) {
    state = [place, ...state];
  }
}

final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  () => UserPlacesNotifier(),
);
