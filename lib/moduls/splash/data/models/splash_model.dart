import '../../domain/entities/splash_entity.dart';

class SplashModel extends SplashEntity {
  const SplashModel({
    required super.isFirstTime,
    required super.isAuthenticated,
  });

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      isFirstTime: json['isFirstTime'] as bool? ?? false,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirstTime': isFirstTime,
      'isAuthenticated': isAuthenticated,
    };
  }
}
