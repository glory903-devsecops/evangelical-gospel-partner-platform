import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/announcements_models.dart';
import '../../../../core/data/repositories/base_repository.dart';
import '../../../../core/domain/entities/announcements.dart';

class EventRepository extends BaseFirestoreRepository<Event> {
  EventRepository({required super.firestore})
      : super(collectionPath: 'events');

  @override
  Event fromFirestore(DocumentSnapshot doc) =>
      EventModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(Event entity) {
    if (entity is EventModel) return entity.toFirestore();
    return {};
  }

  /// 특정 테넌트의 진행 예정 혹은 진행 중인 행사를 가져옵니다.
  Stream<List<Event>> watchActiveEvents(String tenantId) {
    return collection
        .where('tenantId', isEqualTo: tenantId)
        .where('status', isNotEqualTo: 'ended')
        .orderBy('status')
        .orderBy('startAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }
}
