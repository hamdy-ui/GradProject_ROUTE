import 'package:flutter/material.dart';
import '../../moduls/auth/presentation/screens/forget_password_screen.dart';
import '../../moduls/auth/presentation/screens/login_screen.dart';
import '../../moduls/auth/presentation/screens/register_screen.dart';
import '../../moduls/movies/presentation/screens/main_layout_screen.dart';
import '../../moduls/movies/presentation/screens/movie_details_screen.dart';
import '../../moduls/onboarding/presentation/screens/onboarding_screen.dart';
import '../../moduls/profile/presentation/screens/update_profile_screen.dart';
import '../../moduls/splash/presentation/screens/splash_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String movieDetails = '/movie-details';
  static const String browse = '/browse';
  static const String updateProfile = '/update-profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case forgetPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainLayoutScreen(),
          settings: settings,
        );
      case movieDetails:
        final movieId = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MovieDetailsScreen(movieId: movieId),
          settings: settings,
        );
      case browse:
        return MaterialPageRoute(
          builder: (_) => const MainLayoutScreen(initialIndex: 2),
          settings: settings,
        );
      case updateProfile:
        return MaterialPageRoute(
          builder: (_) => const UpdateProfileScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(
              child: Text(
                'Route not found',
                style: AppStyles.font16WhiteRegular,
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
