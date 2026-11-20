import '../../domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthSuccessState extends AuthState {
  final UserEntity user;

  const AuthSuccessState(this.user);
}

class PasswordResetSentState extends AuthState {
  final String message;

  const PasswordResetSentState(this.message);
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage);
}
