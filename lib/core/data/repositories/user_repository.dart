import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user_model.dart';
import './base_repository.dart';

class UserRepository extends BaseFirestoreRepository<AppUserModel> {
  UserRepository({required super.firestore})
      : super(collectionPath: 'users');

  @override
  AppUserModel fromFirestore(DocumentSnapshot doc) =>
      AppUserModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(AppUserModel entity) =>
      entity.toFirestore();

  /// 특정 사용자의 정보를 실시간으로 구독합니다.
  Stream<AppUserModel?> watchUser(String uid) {
    return collection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return fromFirestore(doc);
    });
  }

  /// 새로운 사용자를 등록하거나 기존 정보를 업데이트합니다.
  Future<void> saveUser(AppUserModel user) async {
    await upsert(user.uid, user);
  }

  /// 차단된 사용자 목록을 실시간으로 구독합니다.
  Stream<List<AppUserModel>> watchBlockedUsers() {
    return collection
        .where('isActive', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }

  /// 차단된 사용자 목록을 한 번 가져옵니다.
  Future<List<AppUserModel>> getBlockedUsers() async {
    final snapshot = await collection
        .where('isActive', isEqualTo: false)
        .get();
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }
}
