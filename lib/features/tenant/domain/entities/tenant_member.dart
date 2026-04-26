import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';

class TenantMember {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime joinedAt;
  final DateTime updatedAt;

  TenantMember({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.isActive,
    required this.joinedAt,
    required this.updatedAt,
  });
}
