import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/tenant.dart';

/// 현재 선택된 테넌트 ID를 관리하는 Provider입니다.
final currentTenantIdProvider = StateProvider<String?>((ref) => 'anguk'); // 기본값 안국

/// 모든 테넌트 목록을 가져오는 Provider
final allTenantsProvider = FutureProvider<List<Tenant>>((ref) async {
  final repository = ref.watch(tenantRepositoryProvider);
  return repository.getActiveTenants();
});

/// 현재 선택된 테넌트 정보를 가져오는 Provider
final currentTenantProvider = Provider<Tenant?>((ref) {
  final tenants = ref.watch(allTenantsProvider).value ?? [];
  final currentId = ref.watch(currentTenantIdProvider);
  if (currentId == null) return null;
  
  return tenants.firstWhere(
    (t) => t.id == currentId,
    orElse: () => tenants.isNotEmpty ? tenants.first : _dummyAnkuk,
  );
});

// 데이터가 아직 없을 때를 위한 더미 데이터
final _dummyAnkuk = Tenant(
  id: 'anguk',
  name: '안국역 파트너',
  displayName: '안국역 전도 파트너',
  isActive: true,
  maxConcurrentUsers: 100,
  currentActiveUsers: 0,
  gateEnabled: false,
  primaryColor: '#F06A00', // 3호선 주황
  brandImageUrl: '',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
