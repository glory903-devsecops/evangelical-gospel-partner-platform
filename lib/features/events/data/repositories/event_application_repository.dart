import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evangelical_gospel_partner/core/data/repositories/base_repository.dart';
import 'package:evangelical_gospel_partner/features/events/domain/entities/event_application.dart';

class EventApplicationRepository extends BaseFirestoreRepository<EventApplication> {
  EventApplicationRepository({required super.firestore})
      : super(collectionPath: 'applications');

  @override
  EventApplication fromFirestore(DocumentSnapshot doc) =>
      EventApplicationModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toFirestore(EventApplication entity) {
    if (entity is EventApplicationModel) return entity.toFirestore();
    return {};
  }

  /// 특정 행사에 대한 사용자의 신청 상태를 스트림으로 확인합니다.
  Stream<EventApplication?> watchUserApplication(String eventId, String userId) {
    return collection
        .where('eventId', isEqualTo: eventId)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return fromFirestore(snapshot.docs.first);
    });
  }

  /// 행사에 참가 신청합니다. (트랜잭션 사용)
  Future<void> joinEvent(String tenantId, String eventId, String userId) async {
    final eventRef = firestore.collection('events').doc(eventId);
    final applicationRef = collection.doc('${eventId}_$userId');

    return firestore.runTransaction((transaction) async {
      final eventDoc = await transaction.get(eventRef);
      if (!eventDoc.exists) throw Exception('행사 정보를 찾을 수 없습니다.');

      final data = eventDoc.data()!;
      final max = data['maxApplicants'] ?? 0;
      final current = data['currentApplicants'] ?? 0;

      if (current >= max) throw Exception('정원이 초과되었습니다.');

      final appDoc = await transaction.get(applicationRef);
      if (appDoc.exists) {
        final appData = appDoc.data() as Map<String, dynamic>;
        if (appData['status'] == 'applied') throw Exception('이미 신청한 행사입니다.');
      }

      // 1. 이벤트 인원수 증가
      transaction.update(eventRef, {'currentApplicants': current + 1});

      // 2. 신청 내역 생성/업데이트
      final model = EventApplicationModel(
        id: applicationRef.id,
        tenantId: tenantId,
        eventId: eventId,
        userId: userId,
        status: ApplicationStatus.applied,
        appliedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      transaction.set(applicationRef, model.toFirestore());
    });
  }

  /// 참가 신청을 취소합니다. (트랜잭션 사용)
  Future<void> cancelEvent(String eventId, String userId) async {
    final eventRef = firestore.collection('events').doc(eventId);
    final applicationRef = collection.doc('${eventId}_$userId');

    return firestore.runTransaction((transaction) async {
      final eventDoc = await transaction.get(eventRef);
      final current = eventDoc.data()?['currentApplicants'] ?? 0;

      transaction.update(eventRef, {
        'currentApplicants': (current > 0) ? current - 1 : 0,
      });

      transaction.update(applicationRef, {
        'status': ApplicationStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
