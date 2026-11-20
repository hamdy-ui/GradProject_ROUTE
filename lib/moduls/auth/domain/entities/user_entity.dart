class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final int avatarIndex;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl,
    this.avatarIndex = 0,
  });
}
