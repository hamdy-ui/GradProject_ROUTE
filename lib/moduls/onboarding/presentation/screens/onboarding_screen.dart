import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/data_source/onboarding_local_data_source.dart';
import '../../data/repo/onboarding_repo_impl.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/get_onboarding_items_use_case.dart';
import '../manager/onboarding_manager.dart';
import '../manager/onboarding_state.dart';
import '../widgets/onboarding_page_item_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingManager _manager;

  @override
  void initState() {
    super.initState();
    // Clean Architecture composition root for Onboarding Feature
    const localDataSource = OnboardingLocalDataSourceImpl();
    const repository = OnboardingRepoImpl(localDataSource);
    const getItemsUseCase = GetOnboardingItemsUseCase(repository);
    const completeUseCase = CompleteOnboardingUseCase(repository);

    _manager = OnboardingManager(
      getOnboardingItemsUseCase: getItemsUseCase,
      completeOnboardingUseCase: completeUseCase,
    );

    _manager.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (!mounted) return;
    if (_manager.state is OnboardingCompletedState) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _manager.removeListener(_onStateChanged);
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: PageView.builder(
        controller: _manager.pageController,
        onPageChanged: _manager.onPageChanged,
        physics: const ClampingScrollPhysics(),
        itemCount: _manager.items.length,
        itemBuilder: (context, index) {
          final item = _manager.items[index];
          return OnboardingPageItemWidget(
            item: item,
            onPrimaryPressed: _manager.nextPage,
            onSecondaryPressed: _manager.previousPage,
          );
        },
      ),
    );
  }
}
