import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.primary,
            thickness: 1.2,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: AppStyles.font14PrimaryBold,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.primary,
            thickness: 1.2,
          ),
        ),
      ],
    );
  }
}
