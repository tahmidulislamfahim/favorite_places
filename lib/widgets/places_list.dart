import 'package:favorite_places/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        itemBuilder: (ctx, index) {
          final place = places[index];
          return Dismissible(
            key: ValueKey(place.id),
            direction: DismissDirection.endToStart, // swipe left to delete
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 32),
            ),
            onDismissed: (direction) {
              ref.read(userPlacesProvider.notifier).deletePlace(place.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${place.title} deleted')));
            },
            child: ListTile(
              leading: CircleAvatar(backgroundImage: FileImage(place.image)),
              title: Text(
                place.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                place.location.address,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PlaceDetailsScreen(place: place),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
