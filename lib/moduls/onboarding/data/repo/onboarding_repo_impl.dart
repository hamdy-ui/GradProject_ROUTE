import '../../domain/entities/onboarding_item_entity.dart';
import '../../domain/repo/onboarding_repo.dart';
import '../data_source/onboarding_local_data_source.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  final OnboardingLocalDataSource _dataSource;

  const OnboardingRepoImpl(this._dataSource);

  @override
  List<OnboardingItemEntity> getOnboardingItems() {
    return _dataSource.getOnboardingItems();
  }

  @override
  Future<void> completeOnboarding() async {
    await _dataSource.saveOnboardingCompleted();
  }
}
