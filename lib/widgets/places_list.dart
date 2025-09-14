import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet. Start adding some!',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          // subtitle: Text(places[i].location.address),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailsScreen(place: places[index]),
              ),
            );
          },
        ),
      );
    }
  }
}
