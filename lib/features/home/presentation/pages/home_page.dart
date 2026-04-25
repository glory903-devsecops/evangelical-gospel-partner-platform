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
    
    final tenantNames = {
      'anguk': '안국역 전도 파트너',
      'samseong': '삼성역 전도 파트너',
      'pangyo': '판교역 전도 파트너',
      'dasan': '다산역 전도 파트너',
    };
    final tenantName = tenantNames[tenantId] ?? '전도 파트너';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          tenantName,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
        centerTitle: false,
        shape: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF1A535C),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), activeIcon: Icon(Icons.home_filled), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), activeIcon: Icon(Icons.event_note), label: '행사'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign_rounded), activeIcon: Icon(Icons.campaign), label: '공지'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person), label: '내 정보'),
          ],
        ),
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
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(currentUser?.name ?? "사용자"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 32),
                _buildSectionHeader('최신 공지사항', () => onTabChange(2)),
                const SizedBox(height: 16),
                _buildModernCard(
                  child: noticesAsync.when(
                    data: (notices) => notices.isEmpty 
                      ? const _EmptyState(message: '등록된 공지사항이 없습니다.')
                      : Column(
                          children: notices.take(3).map((n) => _ModernListTile(
                            title: n.title, 
                            date: n.createdAt,
                            isLast: notices.indexOf(n) == (notices.length > 3 ? 2 : notices.length - 1),
                          )).toList(),
                        ),
                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                    error: (e, _) => Text('오류: $e'),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('다가오는 행사', () => onTabChange(1)),
                const SizedBox(height: 16),
                _buildModernCard(
                  child: eventsAsync.when(
                    data: (events) => events.isEmpty 
                      ? const _EmptyState(message: '진행 중인 행사가 없습니다.')
                      : Column(
                          children: events.take(3).map((e) => _ModernListTile(
                            title: e.title, 
                            date: e.startAt,
                            isLast: events.indexOf(e) == (events.length > 3 ? 2 : events.length - 1),
                          )).toList(),
                        ),
                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                    error: (e, _) => Text('오류: $e'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '반가워요, $name님!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A535C), letterSpacing: -1),
              ),
              const SizedBox(width: 8),
              const Text('👋', style: TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '오늘의 교회 소식과 일정을 확인해 보세요.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF1A535C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A535C))),
          ],
        ),
        GestureDetector(
          onTap: onMore,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A535C).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('더보기', style: TextStyle(color: Color(0xFF1A535C), fontWeight: FontWeight.bold, fontSize: 13)),
                Icon(Icons.chevron_right_rounded, color: Color(0xFF1A535C), size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), offset: const Offset(0, 4), blurRadius: 15),
        ],
      ),
      child: child,
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _ActionItem(icon: Icons.qr_code_scanner_rounded, label: '출석체크', color: const Color(0xFF1A535C)),
        const SizedBox(width: 12),
        _ActionItem(icon: Icons.volunteer_activism_rounded, label: '헌금하기', color: const Color(0xFF4ECDC4)),
        const SizedBox(width: 12),
        _ActionItem(icon: Icons.menu_book_rounded, label: '나눔터', color: const Color(0xFFFF6B6B)),
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ModernListTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool isLast;

  const _ModernListTile({required this.title, required this.date, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.circle, color: const Color(0xFF1A535C).withOpacity(0.5), size: 8),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(date),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFEEEEEE), size: 14),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.grey.shade300, size: 48),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
