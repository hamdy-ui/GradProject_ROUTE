import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _authRepo;

  const LoginUseCase(this._authRepo);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return _authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
