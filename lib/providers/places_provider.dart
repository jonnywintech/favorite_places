import 'package:flutter_riverpod/legacy.dart';

import 'package:favorite_places/models/place.dart';

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) {
      return UserPlacesNotifier();
    });

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  void addPlace(Place place) {
    state = [place, ...state];
  }
}
