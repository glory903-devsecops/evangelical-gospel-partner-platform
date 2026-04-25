import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evangelical_gospel_partner/core/data/models/announcements_models.dart';
import 'package:evangelical_gospel_partner/core/data/repositories/base_repository.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';

class NoticeRepository extends BaseFirestoreRepository<Notice> {
  NoticeRepository({required super.firestore})
      : super(collectionPath: 'notices');

  @override
  Notice fromFirestore(DocumentSnapshot doc) =>
      NoticeModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(Notice entity) {
    if (entity is NoticeModel) return entity.toFirestore();
    return {};
  }

  /// 고정된 공지사항을 우선으로 하여 최신순으로 가져옵니다.
  Stream<List<Notice>> watchNotices(String tenantId) {
    return collection
        .where('tenantId', isEqualTo: tenantId)
        .orderBy('isPinned', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }
}
