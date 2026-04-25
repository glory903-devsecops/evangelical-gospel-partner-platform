/// 사용자 정보를 정의하는 엔터티입니다.
enum UserRole {
  user,
  operator,
  admin
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String tenantId;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.tenantId,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
