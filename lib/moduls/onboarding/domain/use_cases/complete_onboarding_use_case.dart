import '../repo/onboarding_repo.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepo _repository;

  const CompleteOnboardingUseCase(this._repository);

  Future<void> call() async {
    await _repository.completeOnboarding();
  }
}
