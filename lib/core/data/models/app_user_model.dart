import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  AppUserModel({
    required super.uid,
    required super.email,
    required super.name,
    super.phone,
    required super.tenantId,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      tenantId: data['tenantId'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (data['role'] ?? 'user'),
        orElse: () => UserRole.user,
      ),
      isActive: data['isActive'] ?? false,
      blockReason: data['blockReason'],
      blockUntil: data['blockUntil'] != null 
          ? (data['blockUntil'] as Timestamp).toDate() 
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'tenantId': tenantId,
      'role': role.name,
      'isActive': isActive,
      'blockReason': blockReason,
      'blockUntil': blockUntil != null ? Timestamp.fromDate(blockUntil!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AppUserModel copyWith({
    String? email,
    String? name,
    String? phone,
    String? tenantId,
    UserRole? role,
    bool? isActive,
    String? blockReason,
    DateTime? blockUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserModel(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      tenantId: tenantId ?? this.tenantId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      blockReason: blockReason ?? this.blockReason,
      blockUntil: blockUntil ?? this.blockUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
