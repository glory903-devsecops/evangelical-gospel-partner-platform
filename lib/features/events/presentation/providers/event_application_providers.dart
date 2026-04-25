import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/features/events/domain/entities/event_application.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 특정 행사에 대한 현재 사용자의 신청 상태를 가져오는 Provider (Family)
final userApplicationStatusProvider = StreamProvider.family<EventApplication?, String>((ref, eventId) {
  final repository = ref.watch(eventApplicationRepositoryProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value(null);
  }

  return repository.watchUserApplication(eventId, user.uid);
});

/// 참가 신청 관련 액션을 처리하는 Provider
final applicationActionsProvider = Provider((ref) {
  final repository = ref.watch(eventApplicationRepositoryProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  final user = FirebaseAuth.instance.currentUser;

  return ApplicationActions(repository, tenantId, user?.uid);
});

class ApplicationActions {
  final dynamic repository;
  final String? tenantId;
  final String? userId;

  ApplicationActions(this.repository, this.tenantId, this.userId);

  Future<void> join(String eventId) async {
    if (tenantId == null || userId == null) throw Exception('로그인이 필요합니다.');
    await repository.joinEvent(tenantId!, eventId, userId!);
  }

  Future<void> cancel(String eventId) async {
    if (userId == null) throw Exception('로그인이 필요합니다.');
    await repository.cancelEvent(eventId, userId!);
  }
}
