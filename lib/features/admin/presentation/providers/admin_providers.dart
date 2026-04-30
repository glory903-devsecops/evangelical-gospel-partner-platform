import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/app_user_model.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:evangelical_gospel_partner/core/data/models/announcements_models.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:evangelical_gospel_partner/core/data/repositories/user_repository.dart';
import 'package:evangelical_gospel_partner/features/notices/data/repositories/notice_repository.dart';
import 'package:evangelical_gospel_partner/core/data/repositories/tenant_repository.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/tenant.dart';

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

/// 모든 테넌트 목록을 관리자용으로 제공하는 Provider (비활성 포함)
final adminAllTenantsProvider = StreamProvider<List<Tenant>>((ref) {
  final repository = ref.watch(tenantRepositoryProvider);
  return repository.collection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => repository.fromFirestore(doc)).toList());
});

/// 관리자 액션을 처리하는 Provider
final adminActionsProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final noticeRepository = ref.watch(noticeRepositoryProvider);
  final tenantRepository = ref.watch(tenantRepositoryProvider);
  return AdminActions(userRepository, noticeRepository, tenantRepository);
});

class AdminActions {
  final UserRepository userRepository;
  final NoticeRepository noticeRepository;
  final TenantRepository tenantRepository;

  AdminActions(this.userRepository, this.noticeRepository, this.tenantRepository);

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
      blockUntil: null,
    );
    await userRepository.saveUser(updatedUser);
  }

  /// 사용자 권한 변경
  Future<void> updateUserRole(AppUserModel user, UserRole newRole) async {
    final updatedUser = user.copyWith(role: newRole);
    await userRepository.saveUser(updatedUser);
  }

  /// 공지사항 삭제
  Future<void> deleteNotice(String noticeId) async {
    await noticeRepository.delete(noticeId);
  }

  /// 테넌트 설정 업데이트
  Future<void> updateTenantSettings({
    required String tenantId,
    required int maxConcurrentUsers,
    required bool gateEnabled,
  }) async {
    final tenant = await tenantRepository.getById(tenantId);
    if (tenant != null) {
      final updatedTenant = tenant.copyWith(
        maxConcurrentUsers: maxConcurrentUsers,
        gateEnabled: gateEnabled,
        updatedAt: DateTime.now(),
      );
      await tenantRepository.upsert(tenantId, updatedTenant);
    }
  }
}
