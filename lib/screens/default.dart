import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';

class Default extends ConsumerWidget {
  const Default({super.key});

  Future<void> _addItem(BuildContext context, WidgetRef ref) async {
    final newPlace = await Navigator.of(context).push<Place>(
      MaterialPageRoute(
        builder: (context) => const AddPlace(),
      ),
    );

    if (newPlace == null) {
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(newPlace);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => _addItem(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PlacesList(places: userPlaces),
    );
  }
}
