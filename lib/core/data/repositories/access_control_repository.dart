import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/access_control_model.dart';
import './base_repository.dart';

class AccessControlRepository extends BaseFirestoreRepository<AccessControlModel> {
  AccessControlRepository({required super.firestore})
      : super(collectionPath: 'access_control');

  @override
  AccessControlModel fromFirestore(DocumentSnapshot doc) =>
      AccessControlModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(AccessControlModel entity) =>
      entity.toFirestore();

  /// 특정 테넌트의 실시간 접속 제어 상태를 구독합니다.
  Stream<AccessControlModel?> watchTenantStatus(String tenantId) {
    return collection.doc(tenantId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return fromFirestore(doc);
    });
  }

  /// 접속자 수를 원자적으로 업데이트합니다. (증가/감소)
  Future<void> updateOccupancy(String tenantId, int delta) async {
    await collection.doc(tenantId).update({
      'currentActiveUsers': FieldValue.increment(delta),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 게이트 활성/비활성화 상태를 변경합니다.
  Future<void> setGateEnabled(String tenantId, bool enabled) async {
    await collection.doc(tenantId).update({
      'gateEnabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
