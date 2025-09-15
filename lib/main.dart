import 'package:favorite_places/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/place_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PlaceLocationHiveAdapter());
  Hive.registerAdapter(PlaceHiveAdapter());

  await Hive.openBox<PlaceHive>('places');

  runApp(const ProviderScope(child: App()));
}
