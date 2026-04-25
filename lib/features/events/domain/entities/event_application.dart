import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus { applied, cancelled }

class EventApplication {
  final String id;
  final String tenantId;
  final String eventId;
  final String userId;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime updatedAt;

  EventApplication({
    required this.id,
    required this.tenantId,
    required this.eventId,
    required this.userId,
    required this.status,
    required this.appliedAt,
    required this.updatedAt,
  });
}

class EventApplicationModel extends EventApplication {
  EventApplicationModel({
    required super.id,
    required super.tenantId,
    required super.eventId,
    required super.userId,
    required super.status,
    required super.appliedAt,
    required super.updatedAt,
  });

  factory EventApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventApplicationModel(
      id: doc.id,
      tenantId: data['tenantId'] ?? '',
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'applied'),
        orElse: () => ApplicationStatus.applied,
      ),
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'eventId': eventId,
      'userId': userId,
      'status': status.name,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
