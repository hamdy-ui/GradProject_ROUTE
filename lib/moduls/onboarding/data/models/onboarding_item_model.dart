import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_item_entity.dart';

class OnboardingItemModel extends OnboardingItemEntity {
  const OnboardingItemModel({
    required super.index,
    required super.title,
    super.description,
    required super.primaryButtonText,
    super.secondaryButtonText,
    required super.imageUrl,
    super.gradientColor,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingItemModel(
      index: json['index'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      primaryButtonText: json['primaryButtonText'] as String,
      secondaryButtonText: json['secondaryButtonText'] as String?,
      imageUrl: json['imageUrl'] as String,
      gradientColor: json['gradientColor'] != null
          ? Color(json['gradientColor'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'title': title,
      'description': description,
      'primaryButtonText': primaryButtonText,
      'secondaryButtonText': secondaryButtonText,
      'imageUrl': imageUrl,
      'gradientColor': gradientColor?.toARGB32(),
    };
  }
}
