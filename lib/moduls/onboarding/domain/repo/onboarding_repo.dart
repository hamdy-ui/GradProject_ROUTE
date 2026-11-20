import '../entities/onboarding_item_entity.dart';

abstract class OnboardingRepo {
  List<OnboardingItemEntity> getOnboardingItems();
  Future<void> completeOnboarding();
}
