import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 선택된 테넌트 ID를 관리하는 Provider입니다.
/// (로그인 시 또는 테넌트 선택 시 업데이트됩니다.)
final currentTenantIdProvider = StateProvider<String?>((ref) {
  return null; 
});
