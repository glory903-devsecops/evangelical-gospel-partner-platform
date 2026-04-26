import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/app_user_model.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:evangelical_gospel_partner/core/data/models/announcements_models.dart';

/// 모든 사용자 목록을 제공하는 Provider
final allUsersProvider = StreamProvider<List<AppUserModel>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.collection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => AppUserModel.fromFirestore(doc)).toList());
});

/// 모든 테넌트의 공지사항을 제공하는 Provider
final allNoticesGlobalProvider = StreamProvider<List<Notice>>((ref) {
  final repository = ref.watch(noticeRepositoryProvider);
  return repository.collection.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => NoticeModel.fromFirestore(doc)).toList());
});

/// 차단된 사용자 목록을 제공하는 Provider
final blockedUsersProvider = StreamProvider<List<AppUserModel>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.watchBlockedUsers();
});

/// 관리자 액션을 처리하는 Provider
final adminActionsProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final noticeRepository = ref.watch(noticeRepositoryProvider);
  return AdminActions(userRepository, noticeRepository);
});

class AdminActions {
  final dynamic userRepository;
  final dynamic noticeRepository;

  AdminActions(this.userRepository, this.noticeRepository);

  /// 사용자 차단 해제
  Future<void> unblockUser(AppUserModel user) async {
    final updatedUser = user.copyWith(
      isActive: true,
      blockReason: null,
      blockUntil: null,
    );
    await userRepository.saveUser(updatedUser);
  }

  /// 사용자 차단 (블랙리스트 추가)
  Future<void> blockUser(AppUserModel user, String reason) async {
    final updatedUser = user.copyWith(
      isActive: false,
      blockReason: reason,
      blockUntil: null, // 영구 차단 혹은 기간 설정 가능
    );
    await userRepository.saveUser(updatedUser);
  }

  /// 공지사항 삭제
  Future<void> deleteNotice(String noticeId) async {
    await noticeRepository.delete(noticeId);
  }
}
