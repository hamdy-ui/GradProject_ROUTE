import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

class GoogleSignInUseCase {
  final AuthRepo _authRepo;

  const GoogleSignInUseCase(this._authRepo);

  Future<UserEntity> call() {
    return _authRepo.loginWithGoogle();
  }
}
