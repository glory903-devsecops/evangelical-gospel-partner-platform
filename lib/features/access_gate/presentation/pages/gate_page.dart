import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/access_control/presentation/providers/access_control_provider.dart';

class GatePage extends ConsumerWidget {
  const GatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessControlAsync = ref.watch(accessControlProvider);

    return accessControlAsync.when(
      data: (state) {
        // 인원수가 확보되어 차단이 해제되면 자동으로 홈으로 이동
        if (!state.isBlocked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1A535C),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_person_rounded, size: 80, color: Colors.white70),
                  const SizedBox(height: 32),
                  Text(
                    '현재 동시 접속 허용 인원은 ${state.maxUsers}명입니다.',
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '현재 접속자 수: ${state.currentUsers}명',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '현재 접속자가 많아 잠시 입장이 제한됩니다.\n잠시 후 다시 시도해 주세요.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ref.read(accessControlActionProvider).recheckStatus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A535C),
                      ),
                      child: const Text('현재 접속자 재확인'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF1A535C),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFF1A535C),
        body: Center(
          child: Text(
            '오류가 발생했습니다: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
