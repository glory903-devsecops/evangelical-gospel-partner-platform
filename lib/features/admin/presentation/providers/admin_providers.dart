import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/app_user_model.dart';

/// 차단된 사용자 목록을 제공하는 Provider
final blockedUsersProvider = StreamProvider<List<AppUserModel>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.watchBlockedUsers();
});

/// 관리자 액션을 처리하는 Provider
final adminActionsProvider = Provider((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return AdminActions(repository);
});

class AdminActions {
  final UserRepository repository;

  AdminActions(this.repository);

  /// 사용자 차단 해제
  Future<void> unblockUser(AppUserModel user) async {
    final updatedUser = user.copyWith(
      isActive: true,
      blockReason: null,
      blockUntil: null,
    );
    await repository.saveUser(updatedUser);
  }
}
