import '../../domain/entities/user_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepoImpl(this._remoteDataSource);

  @override
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) {
    return _remoteDataSource.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatarIndex: avatarIndex,
    );
  }

  @override
  Future<UserEntity> loginWithGoogle() {
    return _remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _remoteDataSource.sendPasswordResetEmail(email: email);
  }
}
