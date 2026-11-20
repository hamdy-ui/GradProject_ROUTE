import 'package:flutter/foundation.dart';
import '../../domain/use_cases/check_initial_status_use_case.dart';
import 'splash_state.dart';

class SplashManager extends ChangeNotifier {
  final CheckInitialStatusUseCase _checkInitialStatusUseCase;

  SplashState _state = const SplashInitialState();
  SplashState get state => _state;

  SplashManager(this._checkInitialStatusUseCase);

  Future<void> init() async {
    _state = const SplashLoadingState();
    notifyListeners();

    try {
      final status = await _checkInitialStatusUseCase();
      if (status.isAuthenticated) {
        _state = const SplashNavigateToHomeState();
      } else if (status.isFirstTime) {
        _state = const SplashNavigateToOnboardingState();
      } else {
        _state = const SplashNavigateToLoginState();
      }
    } catch (e) {
      _state = SplashErrorState(e.toString());
    }
    notifyListeners();
  }
}
