import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/data_source/splash_local_data_source.dart';
import '../../data/repo/splash_repo_impl.dart';
import '../../domain/use_cases/check_initial_status_use_case.dart';
import '../manager/splash_manager.dart';
import '../manager/splash_state.dart';
import '../widgets/splash_footer_widget.dart';
import '../widgets/splash_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashManager _splashManager;

  @override
  void initState() {
    super.initState();
    // Clean Architecture composition root for Splash Feature
    const localDataSource = SplashLocalDataSourceImpl();
    const repository = SplashRepoImpl(localDataSource);
    const useCase = CheckInitialStatusUseCase(repository);
    _splashManager = SplashManager(useCase);

    _splashManager.addListener(_onStateChanged);
    _splashManager.init();
  }

  void _onStateChanged() {
    if (!mounted) return;
    final state = _splashManager.state;
    if (state is SplashNavigateToLoginState) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else if (state is SplashNavigateToHomeState) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (state is SplashNavigateToOnboardingState) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _splashManager.removeListener(_onStateChanged);
    _splashManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SplashLogoWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SplashFooterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
