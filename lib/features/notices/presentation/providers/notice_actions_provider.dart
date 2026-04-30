import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/announcements_models.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart' as auth_core;
import 'package:evangelical_gospel_partner/features/notices/data/repositories/notice_repository.dart';
import 'package:evangelical_gospel_partner/core/data/repositories/user_repository.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

final noticeActionsProvider = Provider((ref) {
  final repository = ref.watch(noticeRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final tenantId = ref.watch(currentTenantIdProvider);
  final user = ref.watch(auth_core.firebaseAuthProvider).currentUser;

  return NoticeActions(repository, userRepository, tenantId, user?.uid);
});

class NoticeActions {
  final NoticeRepository repository;
  final UserRepository userRepository;
  final String? tenantId;
  final String? userId;

  NoticeActions(this.repository, this.userRepository, this.tenantId, this.userId);

  Future<void> createNotice({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    if (tenantId == null || userId == null) return;

    // 1. 하이퍼링크 차단 검사 (Regex)
    final urlPattern = RegExp(r'https?://[^\s]+|www\.[^\s]+');
    if (urlPattern.hasMatch(content) || urlPattern.hasMatch(title)) {
      throw Exception('공지사항에 하이퍼링크를 포함할 수 없습니다.');
    }

    // 2. 도배(Rate Limit) 방지 검사 (1분 내 3회 초과)
    final recentCount = await repository.countRecentNotices(userId!, const Duration(minutes: 1));
    if (recentCount >= 3) {
      // 24시간 차단 처리
      final user = await userRepository.getById(userId!);
      if (user != null) {
        final blockedUser = user.copyWith(
          isActive: false, // isActive를 false로 하여 접근 차단
          blockReason: '공지사항 무단배포 (어뷰징 감지)',
          blockUntil: DateTime.now().add(const Duration(hours: 24)),
        );
        await userRepository.saveUser(blockedUser);
      }
      throw Exception('단시간에 너무 많은 공지사항을 작성하여 계정이 24시간 동안 차단되었습니다.');
    }

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

  Future<void> deleteNotice(String noticeId) async {
    await repository.delete(noticeId);
  }
}
