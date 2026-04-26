import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/tenant.dart';

class TenantModel extends Tenant {
  TenantModel({
    required super.id,
    required super.name,
    required super.displayName,
    required super.isActive,
    required super.maxConcurrentUsers,
    required super.currentActiveUsers,
    required super.gateEnabled,
    required super.primaryColor,
    required super.brandImageUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TenantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TenantModel(
      id: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      isActive: data['isActive'] ?? false,
      maxConcurrentUsers: data['maxConcurrentUsers'] ?? 0,
      currentActiveUsers: data['currentActiveUsers'] ?? 0,
      gateEnabled: data['gateEnabled'] ?? false,
      primaryColor: data['primaryColor'] ?? '#1A535C',
      brandImageUrl: data['brandImageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'displayName': displayName,
      'isActive': isActive,
      'maxConcurrentUsers': maxConcurrentUsers,
      'currentActiveUsers': currentActiveUsers,
      'gateEnabled': gateEnabled,
      'primaryColor': primaryColor,
      'brandImageUrl': brandImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
