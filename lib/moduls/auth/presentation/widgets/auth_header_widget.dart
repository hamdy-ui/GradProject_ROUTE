import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const AuthHeaderWidget({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: Image.asset(
                AppAssets.backArrow,
                width: 24,
                height: 24,
                color: AppColors.primary,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: AppStyles.font16PrimarySemiBold,
          ),
        ],
      ),
    );
  }
}
