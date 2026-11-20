import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/core/constants/app_strings.dart';
import 'package:movie/core/theme/app_theme.dart';
import 'package:movie/main.dart';
import 'package:movie/moduls/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoviesApp());

    expect(find.text(AppStrings.supervisedBy), findsOneWidget);
  });

  testWidgets('Onboarding screen renders first page correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const OnboardingScreen(),
      ),
    );

    expect(find.text('Find Your Next Favorite Movie Here'), findsOneWidget);
    expect(find.text('Explore Now'), findsOneWidget);
  });
}
