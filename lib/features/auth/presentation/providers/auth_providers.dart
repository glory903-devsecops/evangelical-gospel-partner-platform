import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/providers/firestore_providers.dart';
import '../../../../core/domain/entities/app_user.dart';
import '../../../tenant/presentation/providers/tenant_providers.dart';

/// Firebase Auth의 상태 변화를 관찰하는 Provider
final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// 현재 로그인한 사용자의 Firestore 정보를 관찰하는 Provider
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final repository = ref.watch(userRepositoryProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      
      // 사용자가 로그인되어 있다면 Firestore에서 세부 정보를 스트림으로 감시
      return repository.watchUser(user.uid).map((model) {
        if (model != null) {
          // 사용자 정보가 로드되면 전역 테넌트 ID도 업데이트 제안 
          // (주의: Provider 내부에서 다른 StateProvider를 직접 수정하는 것은 부작용을 일으킬 수 있으므로 
          // 실제로는 리스너나 별도 로직을 통해 처리하는 것이 좋습니다.)
          return model;
        }
        return null;
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// 테넌트 ID를 자동으로 동기화하는 로직 (AppUser 로드 시 실행)
final authInitializationProvider = Provider((ref) {
  ref.listen<AsyncValue<AppUser?>>(currentUserProvider, (previous, next) {
    if (next is AsyncData<AppUser?>) {
      final user = next.value;
      if (user != null) {
        // 사용자의 테넌트 ID로 전역 상태 업데이트
        ref.read(currentTenantIdProvider.notifier).state = user.tenantId;
      }
    }
  });
});
