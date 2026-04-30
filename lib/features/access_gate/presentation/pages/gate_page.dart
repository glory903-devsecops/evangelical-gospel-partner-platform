import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/access_control/presentation/providers/access_control_provider.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_actions_provider.dart';

class GatePage extends ConsumerWidget {
  const GatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControlAsync = ref.watch(accessControlProvider);

    return accessControlAsync.when(
      data: (state) {
        if (!state.isBlocked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A535C), Color(0xFF0D2C31)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated-like Lock Icon
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: const Icon(Icons.security_rounded, size: 64, color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        '잠시 대기 중...',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '원활한 서비스 이용을 위해 접속 인원을 조절하고 있습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      
                      // Status Info Box
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            _buildStatusRow('최대 허용 인원', '${state.maxUsers}명'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10),
                            ),
                            _buildStatusRow('현재 접속 중', '${state.currentUsers}명', isHighlight: true),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => ref.read(accessControlActionProvider).recheckStatus(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1A535C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh_rounded),
                              SizedBox(width: 10),
                              Text('현재 상태 새로고침', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () => ref.read(authActionsProvider).logout(),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text('로그아웃하여 계정 전환하기'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF1A535C),
        body: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFF1A535C),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text('오류 발생: $error', style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15)),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF4ECDC4) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
