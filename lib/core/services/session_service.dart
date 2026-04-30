import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 세션 만료 시간을 관리하는 Service
final sessionServiceProvider = Provider((ref) => SessionService());

class SessionService {
  static const String _loginTimeKey = 'last_login_timestamp';
  static const int _sessionDurationHours = 24;

  /// 로그인이 발생했을 때 현재 시간을 저장합니다.
  Future<void> recordLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 세션이 만료되었는지 확인하고, 만료되었다면 로그아웃을 수행합니다.
  Future<bool> checkAndHandleExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getInt(_loginTimeKey);

    if (lastLogin == null) return false;

    final lastLoginDate = DateTime.fromMillisecondsSinceEpoch(lastLogin);
    final now = DateTime.now();
    final difference = now.difference(lastLoginDate);

    if (difference.inHours >= _sessionDurationHours) {
      // 24시간 초과 시 로그아웃
      await FirebaseAuth.instance.signOut();
      await prefs.remove(_loginTimeKey);
      return true; // 세션 만료됨
    }

    return false; // 세션 유효함
  }
}

/// 앱 시작 시 혹은 주기적으로 세션을 체크하는 Provider
final sessionCheckProvider = FutureProvider<void>((ref) async {
  final sessionService = ref.watch(sessionServiceProvider);
  
  // 1. 초기 체크
  await sessionService.checkAndHandleExpiry();

  // 2. 주기적 체크 (예: 1시간마다)
  Timer.periodic(const Duration(hours: 1), (timer) async {
    final isExpired = await sessionService.checkAndHandleExpiry();
    if (isExpired) {
      timer.cancel();
    }
  });
});
