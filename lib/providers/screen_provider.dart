import 'package:flutter_riverpod/legacy.dart';

final screenNameProvider = StateNotifierProvider<ScreenNotifier, String>((ref) {
  return ScreenNotifier();
});

class ScreenNotifier extends StateNotifier<String> {
  ScreenNotifier() : super('Home');

  void setScreenName(String screenName) {
    state = screenName;
  }

  String getScreenName() {
    return state;
  }
}
