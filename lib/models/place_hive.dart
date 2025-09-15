import 'package:hive/hive.dart';

part 'place_hive.g.dart';

@HiveType(typeId: 0)
class PlaceLocationHive extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String address;

  PlaceLocationHive({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

@HiveType(typeId: 1)
class PlaceHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imagePath; // store image path as String

  @HiveField(3)
  final PlaceLocationHive location;

  PlaceHive({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.location,
  });
}
