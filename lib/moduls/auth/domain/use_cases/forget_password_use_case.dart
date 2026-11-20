import '../repo/auth_repo.dart';

class ForgetPasswordUseCase {
  final AuthRepo _authRepo;

  const ForgetPasswordUseCase(this._authRepo);

  Future<void> call({
    required String email,
  }) {
    return _authRepo.sendPasswordResetEmail(email: email);
  }
}
