import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_providers.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 프로필', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
        centerTitle: true,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('사용자 정보를 찾을 수 없습니다.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(user),
                const SizedBox(height: 32),
                _buildSectionTitle('계정 정보'),
                const SizedBox(height: 12),
                _buildInfoCard([
                  _InfoRow(label: '이메일', value: user.email),
                  _InfoRow(label: '연락처', value: user.phone ?? '등록되지 않음'),
                  _InfoRow(label: '소속 테넌트', value: user.tenantId.toUpperCase()),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle('권한 설정'),
                const SizedBox(height: 12),
                _buildInfoCard([
                  _InfoRow(
                    label: '현재 권한', 
                    value: user.role.name.toUpperCase(),
                    valueColor: _getRoleColor(user.role.name),
                  ),
                ]),
                const SizedBox(height: 48),
                _buildLogoutButton(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('오류 발생: $e')),
      ),
    );
  }

  Widget _buildHeader(dynamic user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF1A535C).withOpacity(0.1),
          child: const Icon(Icons.person, size: 40, color: Color(0xFF1A535C)),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)));
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: () => _handleLogout(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          foregroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('로그아웃', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin': return Colors.purple;
      case 'operator': return Colors.blue;
      default: return Colors.green;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}
