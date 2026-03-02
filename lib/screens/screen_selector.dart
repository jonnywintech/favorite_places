import 'package:flutter/material.dart';
import 'package:favorite_places/screens/default.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/providers/screen_provider.dart';

class ScreenSelector extends ConsumerWidget {
  const ScreenSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedScreen = ref.watch(screenNameProvider);

    switch (selectedScreen) {
      case 'Home':
        return const Default();
      default:
        return const Default();
    }
  }
}
