import 'package:flutter_riverpod/legacy.dart';

final splashProvider =
StateNotifierProvider<SplashNotifier, bool>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(false);

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    state = true;
  }
}