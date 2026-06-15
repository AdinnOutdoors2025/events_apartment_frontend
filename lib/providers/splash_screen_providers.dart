import 'package:flutter_riverpod/legacy.dart';
import '../constants/constant.dart';

final splashProvider =
StateNotifierProvider<SplashNotifier, String?>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<String?> {
  SplashNotifier() : super(null);

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      state = '/bottomNav';
    } else {
      state = '/onboarding';
    }
  }
}