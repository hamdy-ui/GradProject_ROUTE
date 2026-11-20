import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo _authRepo;

  const RegisterUseCase(this._authRepo);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) {
    return _authRepo.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }
}
