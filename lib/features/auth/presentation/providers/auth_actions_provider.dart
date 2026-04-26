import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/core/data/models/app_user_model.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authActionsProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  
  return AuthActions(auth, userRepository);
});

class AuthActions {
  final FirebaseAuth _auth;
  final dynamic _userRepository;

  AuthActions(this._auth, this._userRepository);

  /// 새로운 사용자를 등록합니다.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String tenantId,
  }) async {
    try {
      // 1. Firebase Auth 계정 생성
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('사용자 생성에 실패했습니다.');

      // 2. Firestore에 사용자 문서 생성
      final appUser = AppUserModel(
        uid: user.uid,
        email: email,
        name: name,
        tenantId: tenantId,
        joinedTenantIds: [tenantId],
        role: UserRole.user,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUser(appUser);
      
      // 3. 지역별 독립 테이블(members)에 동기화
      await _userRepository.syncToTenant(appUser, tenantId);
      
      // 사용자 표시 이름 업데이트 (옵션)
      await user.updateDisplayName(name);
      
    } catch (e) {
      rethrow;
    }
  }

  /// 구글 계정으로 로그인/가입합니다.
  Future<void> signInWithGoogle({String? tenantId}) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return;

      // Firestore에서 기존 사용자 확인
      final dynamic existingUser = await _userRepository.getUser(user.uid);
      final targetTenantId = tenantId ?? 'anguk';
      
      if (existingUser == null) {
        // 신규 유저인 경우
        final appUser = AppUserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '구글 사용자',
          tenantId: targetTenantId,
          joinedTenantIds: [targetTenantId],
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _userRepository.saveUser(appUser);
        await _userRepository.syncToTenant(appUser, targetTenantId);
      } else {
        // 기존 유저인 경우, 새로운 지역에 가입하는지 확인
        final userModel = existingUser as AppUserModel;
        if (!userModel.joinedTenantIds.contains(targetTenantId)) {
          final updatedUser = userModel.copyWith(
            joinedTenantIds: [...userModel.joinedTenantIds, targetTenantId],
            tenantId: targetTenantId, // 현재 활성 지역 변경
          );
          await _userRepository.saveUser(updatedUser);
          await _userRepository.syncToTenant(updatedUser, targetTenantId);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 기존 사용자로 로그인합니다.
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// 로그아웃합니다.
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
