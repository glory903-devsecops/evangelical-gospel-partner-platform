import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import '../entities/tenant_member.dart';

class TenantMemberModel extends TenantMember {
  TenantMemberModel({
    required super.uid,
    required super.email,
    required super.name,
    super.phone,
    required super.role,
    required super.isActive,
    required super.joinedAt,
    required super.updatedAt,
  });

  factory TenantMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TenantMemberModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'user'),
        orElse: () => UserRole.user,
      ),
      isActive: data['isActive'] ?? false,
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
      'isActive': isActive,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
