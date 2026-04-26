import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/repositories/tenant_repository.dart';
import '../repositories/access_control_repository.dart';
import '../repositories/user_repository.dart';
import '../../../features/notices/data/repositories/notice_repository.dart';
import '../../../features/events/data/repositories/event_repository.dart';
import '../../../features/events/data/repositories/event_application_repository.dart';

/// Firestore 인스턴스 Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// AccessControl 관련 저장소 Provider
final accessControlRepositoryProvider = Provider<AccessControlRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AccessControlRepository(firestore: firestore);
});

/// FirebaseAuth 인스턴스 Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// User 관련 저장소 Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore: firestore);
});

/// Notice 관련 저장소 Provider
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return NoticeRepository(firestore: firestore);
});

/// Event 관련 저장소 Provider
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return EventRepository(firestore: firestore);
});

/// Event Application 관련 저장소 Provider
final eventApplicationRepositoryProvider = Provider<EventApplicationRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return EventApplicationRepository(firestore: firestore);
});

/// Tenant 관련 저장소 Provider
final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return TenantRepository(firestore: firestore);
});



