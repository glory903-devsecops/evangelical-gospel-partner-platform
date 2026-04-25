/// 공지사항 정보를 정의하는 엔터티입니다.
class Notice {
  final String id;
  final String tenantId;
  final String title;
  final String content;
  final bool isPinned;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.tenantId,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// 행사 정보를 정의하는 엔터티입니다.
enum EventStatus {
  open,
  closed,
  ended
}

class Event {
  final String id;
  final String tenantId;
  final String title;
  final String description;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final int maxApplicants;
  final int currentApplicants;
  final EventStatus status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.maxApplicants,
    required this.currentApplicants,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
