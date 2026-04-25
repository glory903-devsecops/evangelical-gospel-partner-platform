/// 접속 제어 상태를 정의하는 엔터티입니다.
class AccessControlState {
  final String tenantId;
  final int currentUsers;
  final int maxUsers;
  final bool isGateEnabled;
  final DateTime updatedAt;

  AccessControlState({
    required this.tenantId,
    required this.currentUsers,
    required this.maxUsers,
    required this.isGateEnabled,
    required this.updatedAt,
  });

  /// 현재 차단 여부를 계산합니다.
  bool get isBlocked => isGateEnabled && (currentUsers >= maxUsers);
}
