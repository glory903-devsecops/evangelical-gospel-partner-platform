import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/providers/event_providers.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeEvents = ref.watch(activeEventsProvider).value ?? [];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('전도 현황', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '우리 지역 활동 요약',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard('진행 중 행사', '${activeEvents.length}', Icons.event_available_rounded, const Color(0xFF1A535C)),
                const SizedBox(width: 16),
                _buildStatCard('활동 파트너', '120+', Icons.people_alt_rounded, const Color(0xFF4ECDC4)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('누적 방문자', '2,450', Icons.trending_up_rounded, const Color(0xFFFF6B6B)),
                const SizedBox(width: 16),
                _buildStatCard('오늘의 전도', '12', Icons.auto_graph_rounded, Colors.orange),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              '최근 활동 추이',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text('활동 그래프가 곧 업데이트될 예정입니다.', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
