import 'package:favorite_places/widgets/my_location.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places/models/place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    Future<void> openGoogleMmap() async {
      final lat = place.location.latitude;
      final lng = place.location.longitude;

      // Try opening in Google Maps app first
      final googleMapsAppUrl = Uri.parse(
        'geo:$lat,$lng?q=$lat,$lng(${place.location.address})',
      );

      // Fallback: open in browser
      final googleMapsWebUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );

      try {
        if (await canLaunchUrl(googleMapsAppUrl)) {
          await launchUrl(
            googleMapsAppUrl,
            mode: LaunchMode.externalApplication,
          );
        } else if (await canLaunchUrl(googleMapsWebUrl)) {
          await launchUrl(
            googleMapsWebUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open Google Maps')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening Google Maps: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Map preview with fixed height
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GestureDetector(
                      onTap: openGoogleMmap,

                      child: CircleAvatar(
                        radius: 70,
                        child: IgnorePointer(
                          // let taps fall through
                          child: MyLocation(pickedLocation: place.location),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
