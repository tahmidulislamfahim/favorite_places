import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String title;

  const AppTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
