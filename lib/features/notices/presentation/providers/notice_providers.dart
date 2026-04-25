import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';

/// 현재 테넌트의 모든 공지사항을 실시간으로 가져오는 Provider
final allNoticesProvider = StreamProvider<List<Notice>>((ref) {
  final tenantId = ref.watch(currentTenantIdProvider);
  final repository = ref.watch(noticeRepositoryProvider);

  if (tenantId == null) {
    return Stream.value([]);
  }

  return repository.watchNotices(tenantId);
});
