import 'package:flutter/material.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/onboarding_item_entity.dart';

class OnboardingBottomSheetWidget extends StatelessWidget {
  final OnboardingItemEntity item;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const OnboardingBottomSheetWidget({
    super.key,
    required this.item,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirstScreen = item.index == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: isFirstScreen
            ? null
            : const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item.title,
            style: isFirstScreen
                ? AppStyles.font32WhiteBold
                : AppStyles.font24WhiteBold,
            textAlign: TextAlign.center,
          ),
          if (item.description != null) ...[
            verticalSpace(12),
            Text(
              item.description!,
              style: isFirstScreen
                  ? AppStyles.font16WhiteRegular.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.5,
                    )
                  : AppStyles.font16WhiteRegular.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
              textAlign: TextAlign.center,
            ),
          ],
          verticalSpace(24),
          CustomButton(
            text: item.primaryButtonText,
            onPressed: onPrimaryPressed,
            backgroundColor: AppColors.primary,
            textColor: AppColors.black,
            borderRadius: 15,
            height: 55,
          ),
          if (item.secondaryButtonText != null) ...[
            verticalSpace(12),
            CustomButton(
              text: item.secondaryButtonText!,
              onPressed: onSecondaryPressed ?? () {},
              backgroundColor: AppColors.scaffoldBackground,
              textColor: AppColors.primary,
              borderRadius: 15,
              height: 55,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
