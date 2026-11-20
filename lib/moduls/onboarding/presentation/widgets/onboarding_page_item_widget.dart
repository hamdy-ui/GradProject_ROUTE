import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/onboarding_item_entity.dart';
import 'onboarding_bottom_sheet_widget.dart';

class OnboardingPageItemWidget extends StatelessWidget {
  final OnboardingItemEntity item;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const OnboardingPageItemWidget({
    super.key,
    required this.item,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (item.index == 0) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.4, 0.7, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0x80121312),
                    Color(0xE8121312),
                    AppColors.scaffoldBackground,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: OnboardingBottomSheetWidget(
                item: item,
                onPrimaryPressed: onPrimaryPressed,
                onSecondaryPressed: onSecondaryPressed,
              ),
            ),
          ),
        ],
      );
    }

    final Color gradientColor = item.gradientColor ?? AppColors.scaffoldBackground;

    return Stack(
      children: [
        // Background poster from local asset
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Image.asset(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient overlay matching Figma to seamlessly blend into bottom card
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 0.85, 1.0],
                colors: [
                  gradientColor.withValues(alpha: 0.0),
                  gradientColor.withValues(alpha: 0.3),
                  gradientColor.withValues(alpha: 0.85),
                  AppColors.scaffoldBackground,
                ],
              ),
            ),
          ),
        ),

        // Bottom sheet card
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: OnboardingBottomSheetWidget(
              item: item,
              onPrimaryPressed: onPrimaryPressed,
              onSecondaryPressed: onSecondaryPressed,
            ),
          ),
        ),
      ],
    );
  }
}
