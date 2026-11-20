import '../../domain/entities/onboarding_item_entity.dart';

sealed class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState();
}

class OnboardingPageChangedState extends OnboardingState {
  final int currentPage;
  final OnboardingItemEntity item;

  const OnboardingPageChangedState({
    required this.currentPage,
    required this.item,
  });
}

class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState();
}
