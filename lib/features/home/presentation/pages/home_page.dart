import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/notices/presentation/pages/notice_list_page.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/pages/event_list_page.dart';
import 'package:evangelical_gospel_partner/features/profile/presentation/pages/profile_page.dart';
import 'package:evangelical_gospel_partner/core/data/providers/firestore_providers.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/features/notices/presentation/providers/notice_providers.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/providers/event_providers.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tenantId = ref.watch(currentTenantIdProvider);
    
    // 테넌트 이름 매핑 (실제로는 Firestore에서 가져오는 것이 좋음)
    final tenantNames = {
      'anguk': '안국역 전도 파트너',
      'samseong': '삼성역 전도 파트너',
      'pangyo': '판교역 전도 파트너',
      'dasan': '다산역 전도 파트너',
    };
    final tenantName = tenantNames[tenantId] ?? '전도 파트너';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tenantName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeSummaryView(onTabChange: (index) => setState(() => _currentIndex = index)),
          const EventListPage(),
          const NoticeListPage(),
          const ProfilePage(),
        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF1A535C),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: '행사'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '공지'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
      ),
    );
  }
}

class _HomeSummaryView extends ConsumerWidget {
  final Function(int) onTabChange;
  
  const _HomeSummaryView({required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(allNoticesProvider);
    final eventsAsync = ref.watch(activeEventsProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '반가워요, ${currentUser?.name ?? "사용자"}님! 👋',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '오늘의 교회 소식을 확인해 보세요.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildQuickActions(),
          const SizedBox(height: 32),
          _buildSectionHeader('최신 공지사항', () => onTabChange(2)),
          const SizedBox(height: 16),
          noticesAsync.when(
            data: (notices) => notices.isEmpty 
              ? const Text('등록된 공지사항이 없습니다.', style: TextStyle(color: Colors.grey))
              : Column(children: notices.take(2).map((n) => _SimpleListTile(title: n.title, date: n.createdAt)).toList()),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('오류: $e'),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('다가오는 행사', () => onTabChange(1)),
          const SizedBox(height: 16),
          eventsAsync.when(
            data: (events) => events.isEmpty 
              ? const Text('진행 중인 행사가 없습니다.', style: TextStyle(color: Colors.grey))
              : Column(children: events.take(2).map((e) => _SimpleListTile(title: e.title, date: e.startAt)).toList()),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('오류: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onMore,
          child: const Text('더보기', style: TextStyle(color: Color(0xFF1A535C))),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _ActionItem(icon: Icons.qr_code_scanner, label: '출석체크', color: const Color(0xFF1A535C)),
        const SizedBox(width: 16),
        _ActionItem(icon: Icons.volunteer_activism, label: '헌금하기', color: const Color(0xFF4ECDC4)),
        const SizedBox(width: 16),
        _ActionItem(icon: Icons.menu_book, label: '나눔터', color: const Color(0xFFFF6B6B)),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _SimpleListTile extends StatelessWidget {
  final String title;
  final DateTime date;

  const _SimpleListTile({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            DateFormat('MM.dd').format(date),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
