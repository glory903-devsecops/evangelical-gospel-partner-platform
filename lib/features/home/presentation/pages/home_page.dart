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
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) hexColor = 'FF$hexColor';
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF1A535C);
    }
  }

  void _showTenantPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('활동 지역 변경', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A535C))),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final tenantsAsync = ref.watch(allTenantsProvider);
                  return tenantsAsync.when(
                    data: (tenants) => Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tenants.length,
                        itemBuilder: (context, index) {
                          final t = tenants[index];
                          final isSelected = t.id == ref.watch(currentTenantIdProvider);
                          final tColor = _parseColor(t.primaryColor);
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: tColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on_rounded, color: tColor, size: 20),
                            ),
                            title: Text(
                              t.name, 
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? tColor : Colors.black87,
                              )
                            ),
                            trailing: isSelected ? Icon(Icons.check_circle_rounded, color: tColor) : null,
                            onTap: () {
                              ref.read(currentTenantIdProvider.notifier).state = t.id;
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                    loading: () => const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
                    error: (e, _) => Text('오류: $e'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTenant = ref.watch(currentTenantProvider);
    final primaryColor = _parseColor(currentTenant?.primaryColor ?? '#1A535C');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showTenantPicker(context, ref),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentTenant?.name ?? '전도 파트너',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: primaryColor),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 24, color: Colors.redAccent),
            onPressed: () => ref.read(authActionsProvider).signOut(),
            tooltip: '로그아웃',
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        shape: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A535C), Color(0xFF4ECDC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF1A535C)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ref.watch(currentUserProvider).value?.name ?? '사용자',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ref.watch(currentUserProvider).value?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('홈'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            if (ref.watch(currentUserProvider).value?.role == UserRole.admin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
                title: const Text('운영자 패널', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/admin');
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('로그아웃', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                ref.read(authActionsProvider).signOut();
              },
            ),
          ],
        ),
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
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(allNoticesProvider);
    final eventsAsync = ref.watch(activeEventsProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final currentTenant = ref.watch(currentTenantProvider);
    
    // Helper to parse hex color
    Color parseColor(String hexColor) {
      try {
        hexColor = hexColor.replaceAll('#', '');
        if (hexColor.length == 6) hexColor = 'FF$hexColor';
        return Color(int.parse(hexColor, radix: 16));
      } catch (e) {
        return const Color(0xFF1A535C);
      }
    }
    
    final primaryColor = parseColor(currentTenant?.primaryColor ?? '#1A535C');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(currentUser?.name ?? "사용자", primaryColor, currentTenant?.brandImageUrl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildQuickActions(primaryColor),
                const SizedBox(height: 32),
                _buildSectionHeader('최신 공지사항', primaryColor, () => onTabChange(2)),
                const SizedBox(height: 16),
                _buildModernCard(
                  child: noticesAsync.when(
                    data: (notices) => notices.isEmpty 
                      ? const _EmptyState(message: '등록된 공지사항이 없습니다.')
                      : Column(
                           children: notices.take(3).map((n) => _ModernListTile(
                            title: n.title, 
                            date: n.createdAt,
                            primaryColor: primaryColor,
                            isLast: notices.indexOf(n) == (notices.length > 3 ? 2 : notices.length - 1),
                          )).toList(),
                        ),
                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                    error: (e, _) => Text('오류: $e'),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('다가오는 행사', primaryColor, () => onTabChange(1)),
                const SizedBox(height: 16),
                _buildModernCard(
                  child: eventsAsync.when(
                    data: (events) => events.isEmpty 
                      ? const _EmptyState(message: '진행 중인 행사가 없습니다.')
                      : Column(
                           children: events.take(3).map((e) => _ModernListTile(
                            title: e.title, 
                            date: e.startAt,
                            primaryColor: primaryColor,
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

  Widget _buildHeroHeader(String name, Color primaryColor, String? imageUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 20),
        ],
        image: (imageUrl != null && imageUrl.isNotEmpty)
          ? DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.92), BlendMode.screen),
            )
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '반가워요, $name님!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: -1),
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

  Widget _buildSectionHeader(String title, Color primaryColor, VoidCallback onMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primaryColor)),
          ],
        ),
        GestureDetector(
          onTap: onMore,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text('더보기', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                Icon(Icons.chevron_right_rounded, color: primaryColor, size: 16),
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

  Widget _buildQuickActions(Color primaryColor) {
    return Row(
      children: [
        _ActionItem(icon: Icons.qr_code_scanner_rounded, label: '출석체크', color: primaryColor),
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
  final Color primaryColor;

  const _ModernListTile({
    required this.title, 
    required this.date, 
    required this.primaryColor,
    this.isLast = false,
  });

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
            child: Icon(Icons.circle, color: primaryColor.withOpacity(0.5), size: 8),
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
