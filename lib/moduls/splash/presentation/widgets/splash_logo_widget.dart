import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';

class SplashLogoWidget extends StatelessWidget {
  final double size;

  const SplashLogoWidget({
    super.key,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.logo,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
