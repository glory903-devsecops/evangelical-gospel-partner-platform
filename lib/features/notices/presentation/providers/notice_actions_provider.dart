import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/announcements_models.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart' as auth_core;
import 'package:firebase_auth/firebase_auth.dart';

final noticeActionsProvider = Provider((ref) {
  final repository = ref.watch(noticeRepositoryProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  final user = ref.watch(auth_core.firebaseAuthProvider).currentUser;

  return NoticeActions(repository, tenantId, user?.uid);
});

class NoticeActions {
  final dynamic repository;
  final String? tenantId;
  final String? userId;

  NoticeActions(this.repository, this.tenantId, this.userId);

  Future<void> createNotice({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    if (tenantId == null || userId == null) return;

    final notice = NoticeModel(
      id: '', // Firestore will generate this
      tenantId: tenantId!,
      title: title,
      content: content,
      isPinned: isPinned,
      createdBy: userId!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repository.add(notice);
  }
}
