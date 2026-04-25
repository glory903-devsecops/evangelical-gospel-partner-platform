import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_providers.dart';
import 'package:evangelical_gospel_partner/features/access_control/presentation/providers/access_control_provider.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/pages/login_page.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/pages/signup_page.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/pages/tenant_select_page.dart';
import 'package:evangelical_gospel_partner/features/home/presentation/pages/home_page.dart';
import 'package:evangelical_gospel_partner/features/access_gate/presentation/pages/gate_page.dart';
import 'package:evangelical_gospel_partner/features/notices/presentation/pages/notice_detail_page.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/pages/event_detail_page.dart';
import 'package:evangelical_gospel_partner/features/notices/presentation/pages/notice_editor_page.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/pages/event_editor_page.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';

import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart' as evt;

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final accessControl = ref.watch(accessControlProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      if (!isLoggedIn) {
        return (isLoggingIn || isSigningUp) ? null : '/login';
      }

      // 로그인된 경우, 게이트 상태 확인
      final gateState = ref.read(accessControlProvider).value;
      if (gateState != null && gateState.isBlocked && state.matchedLocation != '/gate') {
        return '/gate';
      }

      if (isLoggedIn && isLoggingIn) return '/home';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        path: '/tenant-select',
        builder: (context, state) => const TenantSelectPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/gate',
        builder: (context, state) => const GatePage(),
      ),
      GoRoute(
        path: '/notice-detail',
        builder: (context, state) {
          final notice = state.extra as Notice;
          return NoticeDetailPage(notice: notice);
        },
      ),
      GoRoute(
        path: '/event-detail',
        builder: (context, state) {
          final event = state.extra as evt.Event;
          return EventDetailPage(event: event);
        },
      ),
      GoRoute(
        path: '/notice-edit',
        builder: (context, state) => const NoticeEditorPage(),
      ),
      GoRoute(
        path: '/event-edit',
        builder: (context, state) => const EventEditorPage(),
      ),
    ],
  );
});
