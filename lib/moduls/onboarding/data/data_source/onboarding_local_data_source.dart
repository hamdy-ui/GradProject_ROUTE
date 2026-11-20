import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../models/onboarding_item_model.dart';

abstract class OnboardingLocalDataSource {
  List<OnboardingItemModel> getOnboardingItems();
  Future<void> saveOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl();

  @override
  List<OnboardingItemModel> getOnboardingItems() {
    return const [
      OnboardingItemModel(
        index: 0,
        title: 'Find Your Next Favorite Movie Here',
        description:
            'Get access to a huge library of movies to suit all tastes. You will surely like it.',
        primaryButtonText: 'Explore Now',
        secondaryButtonText: null,
        imageUrl: AppAssets.onboarding1,
        gradientColor: Color(0xFF121312),
      ),
      OnboardingItemModel(
        index: 1,
        title: 'Discover Movies',
        description:
            'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
        primaryButtonText: 'Next',
        secondaryButtonText: null,
        imageUrl: AppAssets.onboarding2,
        gradientColor: Color(0xFF084250),
      ),
      OnboardingItemModel(
        index: 2,
        title: 'Explore All Genres',
        description:
            'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
        primaryButtonText: 'Next',
        secondaryButtonText: 'Back',
        imageUrl: AppAssets.onboarding3,
        gradientColor: Color(0xFF85210E),
      ),
      OnboardingItemModel(
        index: 3,
        title: 'Create Watchlists',
        description:
            'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
        primaryButtonText: 'Next',
        secondaryButtonText: 'Back',
        imageUrl: AppAssets.onboarding4,
        gradientColor: Color(0xFF4C2471),
      ),
      OnboardingItemModel(
        index: 4,
        title: 'Rate, Review, and Learn',
        description:
            'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
        primaryButtonText: 'Next',
        secondaryButtonText: 'Back',
        imageUrl: AppAssets.onboarding5,
        gradientColor: Color(0xFF601321),
      ),
      OnboardingItemModel(
        index: 5,
        title: 'Start Watching Now',
        description: null,
        primaryButtonText: 'Finish',
        secondaryButtonText: 'Back',
        imageUrl: AppAssets.onboarding6,
        gradientColor: Color(0xFF2A2C30),
      ),
    ];
  }

  @override
  Future<void> saveOnboardingCompleted() async {
    // Simulated persistent save (e.g. SharedPreferences)
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
