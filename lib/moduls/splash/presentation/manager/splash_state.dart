sealed class SplashState {
  const SplashState();
}

class SplashInitialState extends SplashState {
  const SplashInitialState();
}

class SplashLoadingState extends SplashState {
  const SplashLoadingState();
}

class SplashNavigateToLoginState extends SplashState {
  const SplashNavigateToLoginState();
}

class SplashNavigateToOnboardingState extends SplashState {
  const SplashNavigateToOnboardingState();
}

class SplashNavigateToHomeState extends SplashState {
  const SplashNavigateToHomeState();
}

class SplashErrorState extends SplashState {
  final String message;
  const SplashErrorState(this.message);
}
