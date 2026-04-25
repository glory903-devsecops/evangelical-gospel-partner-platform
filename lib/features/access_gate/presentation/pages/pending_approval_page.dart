import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_actions_provider.dart';

class PendingApprovalPage extends ConsumerWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FFF7), Color(0xFFE8F1F2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A535C).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.hourglass_empty_rounded, size: 64, color: Color(0xFF1A535C)),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '가입 승인 대기 중',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A535C),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '운영진이 회원님의 가입 신청을 확인하고 있습니다.\n승인이 완료되면 모든 서비스를 이용하실 수 있습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Instruction Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Column(
                      children: [
                        _InfoRow(icon: Icons.check_circle_outline, text: '회원가입 정보 확인 중'),
                        SizedBox(height: 16),
                        _InfoRow(icon: Icons.check_circle_outline, text: '소속 테넌트 권한 확인 중'),
                        SizedBox(height: 16),
                        _InfoRow(icon: Icons.help_outline, text: '문의: @glory903'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () => ref.read(authActionsProvider).logout(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1A535C)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('로그아웃', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A535C))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1A535C), size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
