import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theme/app_styles.dart';

class SplashFooterWidget extends StatelessWidget {
  const SplashFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.routeGold,
          width: 180,
          fit: BoxFit.contain,
        ),
        verticalSpace(8),
        const Text(
          AppStrings.supervisedBy,
          style: AppStyles.font16WhiteRegular,
          textAlign: TextAlign.center,
        ),
        verticalSpace(24),
      ],
    );
  }
}
