import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  });

  Future<UserEntity> loginWithGoogle();

  Future<void> sendPasswordResetEmail({
    required String email,
  });
}
