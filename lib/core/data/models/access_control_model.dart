import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/access_control_state.dart';

class AccessControlModel extends AccessControlState {
  AccessControlModel({
    required super.tenantId,
    required super.currentUsers,
    required super.maxUsers,
    required super.isGateEnabled,
    required super.updatedAt,
  });

  factory AccessControlModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccessControlModel(
      tenantId: doc.id,
      currentUsers: data['currentActiveUsers'] ?? 0,
      maxUsers: data['maxConcurrentUsers'] ?? 0,
      isGateEnabled: data['gateEnabled'] ?? false,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'currentActiveUsers': currentUsers,
      'maxConcurrentUsers': maxUsers,
      'gateEnabled': isGateEnabled,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
