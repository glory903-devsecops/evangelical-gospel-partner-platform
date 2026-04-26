import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_providers.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('운영자 마스터 패널', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people_alt_rounded), text: '사용자'),
              Tab(icon: Icon(Icons.block_flipped), text: '블랙리스트'),
              Tab(icon: Icon(Icons.campaign_rounded), text: '공지사항'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 3,
          ),
        ),
        body: const TabBarView(
          children: [
            _UserManagementTab(),
            _BlacklistTab(),
            _NoticeManagementTab(),
          ],
        ),
      ),
    );
  }
}

class _UserManagementTab extends ConsumerWidget {
  const _UserManagementTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return usersAsync.when(
      data: (users) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.isActive ? Colors.blue[50] : Colors.red[50],
                child: Icon(
                  user.isActive ? Icons.person_rounded : Icons.person_off_rounded,
                  color: user.isActive ? Colors.blue : Colors.red,
                ),
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${user.email}\n지역: ${user.joinedTenantIds.join(", ")}'),
              isThreeLine: true,
              trailing: user.isActive 
                ? IconButton(
                    icon: const Icon(Icons.block, color: Colors.redAccent),
                    onPressed: () => _showBlockDialog(context, ref, user),
                  )
                : const Icon(Icons.verified_user, color: Colors.grey),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
    );
  }

  void _showBlockDialog(BuildContext context, WidgetRef ref, AppUserModel user) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.name} 차단'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(hintText: '차단 사유를 입력하세요'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              ref.read(adminActionsProvider).blockUser(user, reasonController.text);
              Navigator.pop(context);
            },
            child: const Text('차단 확정', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _BlacklistTab extends ConsumerWidget {
  const _BlacklistTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsersAsync = ref.watch(blockedUsersProvider);

    return blockedUsersAsync.when(
      data: (users) => users.isEmpty
        ? const Center(child: Text('차단된 사용자가 없습니다.'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                color: Colors.red[50],
                child: ListTile(
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('사유: ${user.blockReason ?? "없음"}'),
                  trailing: TextButton(
                    onPressed: () => ref.read(adminActionsProvider).unblockUser(user),
                    child: const Text('차단 해제'),
                  ),
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
    );
  }
}

class _NoticeManagementTab extends ConsumerWidget {
  const _NoticeManagementTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(allNoticesGlobalProvider);

    return noticesAsync.when(
      data: (notices) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.campaign, color: Colors.orange),
              title: Text(notice.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('테넌트: ${notice.tenantId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context, ref, notice.id),
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String noticeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공지 삭제'),
        content: const Text('이 공지사항을 영구적으로 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              ref.read(adminActionsProvider).deleteNotice(noticeId);
              Navigator.pop(context);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
