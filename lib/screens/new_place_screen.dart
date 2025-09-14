import 'dart:io';

import 'package:favorite_places/common/title.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;

  void _addPlace() {
    final enteredTitle = _titleController.text;
    final newPlace = Place(
      title: enteredTitle,
      image: _selectedImage!,
    ); // later add image/location here
    if (enteredTitle.isEmpty || _selectedImage == null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(newPlace);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppTitle(title: 'Add New Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            SizedBox(height: 10),
            LocationInput(),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addPlace,
              icon: Icon(Icons.add),
              label: Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
