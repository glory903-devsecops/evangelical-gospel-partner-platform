import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';

/// 현재 테넌트의 활성 행사들을 실시간으로 가져오는 Provider
final activeEventsProvider = StreamProvider<List<Event>>((ref) {
  final tenantId = ref.watch(currentTenantIdProvider);
  final repository = ref.watch(eventRepositoryProvider);

  if (tenantId == null) {
    return Stream.value([]);
  }

  return repository.watchActiveEvents(tenantId);
});
