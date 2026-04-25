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
}
