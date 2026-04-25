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
        role: UserRole.user,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _userRepository.saveUser(appUser);
      
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
      if (googleUser == null) return; // 사용자가 취소함

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return;

      // Firestore에서 기존 사용자 확인
      final existingUser = await _userRepository.getUser(user.uid);
      
      if (existingUser == null) {
        // 신규 유저인 경우 프로필 생성
        final appUser = AppUserModel(
          uid: user.uid,
          email: user.email,
          name: user.displayName ?? '구글 사용자',
          tenantId: tenantId ?? 'unknown', // 기본값 혹은 전달받은 값
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _userRepository.saveUser(appUser);
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
