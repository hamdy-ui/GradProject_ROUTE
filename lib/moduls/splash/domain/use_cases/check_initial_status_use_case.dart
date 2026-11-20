import '../entities/splash_entity.dart';
import '../repo/splash_repo.dart';

class CheckInitialStatusUseCase {
  final SplashRepo _splashRepo;

  const CheckInitialStatusUseCase(this._splashRepo);

  Future<SplashEntity> call() async {
    return await _splashRepo.checkInitialStatus();
  }
}
