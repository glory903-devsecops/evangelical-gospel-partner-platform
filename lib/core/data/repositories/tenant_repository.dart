import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tenant_model.dart';
import './base_repository.dart';

class TenantRepository extends BaseFirestoreRepository<TenantModel> {
  TenantRepository({required super.firestore})
      : super(collectionPath: 'tenants');

  @override
  TenantModel fromFirestore(DocumentSnapshot doc) =>
      TenantModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(TenantModel entity) =>
      entity.toFirestore();

  /// 모든 활성화된 테넌트 목록을 가져옵니다.
  Future<List<TenantModel>> getActiveTenants() async {
    final snapshot = await collection.where('isActive', isEqualTo: true).get();
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }
}
