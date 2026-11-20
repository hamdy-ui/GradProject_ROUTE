import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/repo/auth_repo_impl.dart';
import '../../domain/use_cases/forget_password_use_case.dart';
import '../../domain/use_cases/google_sign_in_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleSignInUseCase,
    required this.forgetPasswordUseCase,
  }) : super(const AuthInitialState());

  /// Factory helper for composition root
  factory AuthCubit.create() {
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final repository = AuthRepoImpl(remoteDataSource);
    return AuthCubit(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      googleSignInUseCase: GoogleSignInUseCase(repository),
      forgetPasswordUseCase: ForgetPasswordUseCase(repository),
    );
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoadingState());
    try {
      final user = await loginUseCase(
        email: email,
        password: password,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatarIndex,
  }) async {
    emit(const AuthLoadingState());
    try {
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatarIndex: avatarIndex,
      );
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthLoadingState());
    try {
      final user = await googleSignInUseCase();
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    emit(const AuthLoadingState());
    try {
      await forgetPasswordUseCase(email: email);
      emit(const PasswordResetSentState(
        'Password reset email sent! Please check your inbox.',
      ));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void resetState() {
    emit(const AuthInitialState());
  }
}
