import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/announcements.dart';

class NoticeModel extends Notice {
  NoticeModel({
    required super.id,
    required super.tenantId,
    required super.title,
    required super.content,
    required super.isPinned,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoticeModel(
      id: doc.id,
      tenantId: data['tenantId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      isPinned: data['isPinned'] ?? false,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'title': title,
      'content': content,
      'isPinned': isPinned,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.tenantId,
    required super.title,
    required super.description,
    required super.location,
    required super.startAt,
    required super.endAt,
    required super.maxApplicants,
    required super.currentApplicants,
    required super.status,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      tenantId: data['tenantId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt: (data['endAt'] as Timestamp).toDate(),
      maxApplicants: data['maxApplicants'] ?? 0,
      currentApplicants: data['currentApplicants'] ?? 0,
      status: EventStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'open'),
        orElse: () => EventStatus.open,
      ),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'title': title,
      'description': description,
      'location': location,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'maxApplicants': maxApplicants,
      'currentApplicants': currentApplicants,
      'status': status.name,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
