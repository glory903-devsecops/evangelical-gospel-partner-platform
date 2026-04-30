import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/church_model.dart';

class ChurchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('churches');

  /// 특정 테넌트(지역)의 교회 목록을 가져옵니다.
  Stream<List<ChurchModel>> getChurchesByTenant(String tenantId) {
    return _collection
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChurchModel.fromFirestore(doc))
            .toList());
  }

  /// 새로운 교회를 등록합니다.
  Future<void> addChurch(ChurchModel church) async {
    await _collection.add(church.toFirestore());
  }

  /// 교회 정보를 업데이트합니다.
  Future<void> updateChurch(ChurchModel church) async {
    await _collection.doc(church.id).update(church.toFirestore());
  }

  /// 교회를 삭제합니다.
  Future<void> deleteChurch(String churchId) async {
    await _collection.doc(churchId).delete();
  }
}
