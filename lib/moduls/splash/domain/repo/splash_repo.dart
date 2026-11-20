import '../entities/splash_entity.dart';

abstract class SplashRepo {
  Future<SplashEntity> checkInitialStatus();
}
