import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/tenant/presentation/pages/tenant_select_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/access_gate/presentation/pages/gate_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
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
    ],
  );
});
