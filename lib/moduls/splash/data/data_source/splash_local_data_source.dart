import '../models/splash_model.dart';

abstract class SplashLocalDataSource {
  Future<SplashModel> getInitialStatus();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  const SplashLocalDataSourceImpl();

  @override
  Future<SplashModel> getInitialStatus() async {
    // Simulate initial loading / delay (e.g. 3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    return const SplashModel(
      isFirstTime: true,
      isAuthenticated: false,
    );
  }
}
