class Church {
  final String id;
  final String tenantId; // 소속 지역 ID
  final String name; // 교회 이름
  final String denomination; // 교단
  final String pastorName; // 담임 목사
  final int memberCount; // 성도 수
  final int youthCount; // 청년 수
  final int distance; // 전철역에서의 거리 (m)
  final String address; // 주소
  final double? latitude; // 위도
  final double? longitude; // 경도
  final String yearlyWord; // 올해 하나님이 주신 말씀
  final DateTime createdAt;
  final DateTime updatedAt;

  Church({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.denomination,
    required this.pastorName,
    required this.memberCount,
    required this.youthCount,
    required this.distance,
    required this.address,
    this.latitude,
    this.longitude,
    required this.yearlyWord,
    required this.createdAt,
    required this.updatedAt,
  });
}
