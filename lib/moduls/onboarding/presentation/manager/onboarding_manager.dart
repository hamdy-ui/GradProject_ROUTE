import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_item_entity.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/get_onboarding_items_use_case.dart';
import 'onboarding_state.dart';

class OnboardingManager extends ChangeNotifier {
  final GetOnboardingItemsUseCase getOnboardingItemsUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  late final List<OnboardingItemEntity> items;
  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  OnboardingState _state = const OnboardingInitialState();
  OnboardingState get state => _state;

  OnboardingManager({
    required this.getOnboardingItemsUseCase,
    required this.completeOnboardingUseCase,
  }) {
    items = getOnboardingItemsUseCase();
    _state = OnboardingPageChangedState(
      currentPage: 0,
      item: items.first,
    );
  }

  void onPageChanged(int index) {
    _currentPage = index;
    _state = OnboardingPageChangedState(
      currentPage: index,
      item: items[index],
    );
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> finish() async {
    await completeOnboardingUseCase();
    _state = const OnboardingCompletedState();
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
