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
  final String? birthDate; // 생년월일 6자리 (예: 900101)
  final String tenantId;
  final List<String> joinedTenantIds;
  final UserRole role;
  final bool isActive;
  final String? blockReason;
  final DateTime? blockUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.birthDate,
    required this.tenantId,
    this.joinedTenantIds = const [],
    required this.role,
    required this.isActive,
    this.blockReason,
    this.blockUntil,
    required this.createdAt,
    required this.updatedAt,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? birthDate,
    String? tenantId,
    List<String>? joinedTenantIds,
    UserRole? role,
    bool? isActive,
    String? blockReason,
    DateTime? blockUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      tenantId: tenantId ?? this.tenantId,
      joinedTenantIds: joinedTenantIds ?? this.joinedTenantIds,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      blockReason: blockReason ?? this.blockReason,
      blockUntil: blockUntil ?? this.blockUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
