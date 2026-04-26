/// 테넌트(교회별) 정보를 정의하는 엔터티입니다.
class Tenant {
  final String id; // 예: 'anguk', 'samseong'
  final String name; // 예: '안국교회'
  final String displayName; // 표시용 이름
  final bool isActive;
  final int maxConcurrentUsers;
  final int currentActiveUsers;
  final bool gateEnabled; // 접속 게이트 활성화 여부
  final String primaryColor; // 메인 브랜드 색상 (Hex 코드)
  final String brandImageUrl; // 브랜드 대표 이미지 URL
  final DateTime createdAt;
  final DateTime updatedAt;

  Tenant({
    required this.id,
    required this.name,
    required this.displayName,
    required this.isActive,
    required this.maxConcurrentUsers,
    required this.currentActiveUsers,
    required this.gateEnabled,
    required this.primaryColor,
    required this.brandImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
