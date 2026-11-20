import 'package:flutter/material.dart';

class OnboardingItemEntity {
  final int index;
  final String title;
  final String? description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final String imageUrl;
  final Color? gradientColor;

  const OnboardingItemEntity({
    required this.index,
    required this.title,
    this.description,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.imageUrl,
    this.gradientColor,
  });
}
