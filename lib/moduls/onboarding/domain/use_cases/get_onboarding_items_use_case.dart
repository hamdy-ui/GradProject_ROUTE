import '../entities/onboarding_item_entity.dart';
import '../repo/onboarding_repo.dart';

class GetOnboardingItemsUseCase {
  final OnboardingRepo _repository;

  const GetOnboardingItemsUseCase(this._repository);

  List<OnboardingItemEntity> call() {
    return _repository.getOnboardingItems();
  }
}
