import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/providers/firestore_providers.dart';
import '../../../tenant/presentation/providers/tenant_providers.dart';
import '../../../../core/domain/entities/access_control_state.dart';

/// 현재 접속 상태를 관리하는 Provider입니다.
/// Firestore 실시간 스트림을 구독하여 상태가 변할 때마다 UI를 업데이트합니다.
final accessControlProvider = StreamProvider<AccessControlState>((ref) {
  final tenantId = ref.watch(currentTenantIdProvider);
  final repository = ref.watch(accessControlRepositoryProvider);

  if (tenantId == null) {
    // 테넌트가 선택되지 않은 경우 더미 데이터 혹은 에러를 던질 수 있습니다.
    return Stream.value(AccessControlState(
      tenantId: 'unknown',
      currentUsers: 0,
      maxUsers: 0,
      isGateEnabled: false,
      updatedAt: DateTime.now(),
    ));
  }

  return repository.watchTenantStatus(tenantId).map((model) {
    if (model == null) {
      // 문서가 없는 경우 초기 상태 반환
      return AccessControlState(
        tenantId: tenantId,
        currentUsers: 0,
        maxUsers: 100,
        isGateEnabled: false,
        updatedAt: DateTime.now(),
      );
    }
    return model;
  });
});

/// 접속 제어 관련 동작을 관리하는 Provider
final accessControlActionProvider = Provider((ref) {
  final repository = ref.watch(accessControlRepositoryProvider);
  final tenantId = ref.watch(currentTenantIdProvider);

  return AccessControlActions(repository, tenantId);
});

class AccessControlActions {
  final dynamic _repository;
  final String? _tenantId;

  AccessControlActions(this._repository, this._tenantId);

  Future<void> recheckStatus() async {
    if (_tenantId == null) return;
    // 실제 재확인 로직 (예: 수동 리프레시 유도 등 상황에 따라 다름)
    // Firestore 스트림이 활성 상태이므로 버튼 클릭 시 별도 처리 없이 리프레시 로딩 효과만 줄 수 있습니다.
  }
}
