import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.phone = '',
    super.avatarUrl,
    super.avatarIndex = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? uid}) {
    return UserModel(
      uid: uid ?? json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      avatarIndex: (json['avatarIndex'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'avatarIndex': avatarIndex,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
