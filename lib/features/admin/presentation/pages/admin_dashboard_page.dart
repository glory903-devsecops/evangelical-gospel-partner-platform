import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:evangelical_gospel_partner/core/data/models/app_user_model.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/tenant.dart';
import '../providers/admin_providers.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
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
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.people_alt_rounded), text: '사용자'),
              Tab(icon: Icon(Icons.block_flipped), text: '블랙리스트'),
              Tab(icon: Icon(Icons.campaign_rounded), text: '공지사항'),
              Tab(icon: Icon(Icons.settings_suggest_rounded), text: '테넌트 설정'),
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
            _TenantSettingsTab(),
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
              subtitle: Text('${user.email}\n역할: ${user.role.name.toUpperCase()} / 지역: ${user.joinedTenantIds.join(", ")}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.blueGrey),
                    onPressed: () => _showRoleDialog(context, ref, user),
                    tooltip: '권한 변경',
                  ),
                  if (user.isActive)
                    IconButton(
                      icon: const Icon(Icons.block, color: Colors.redAccent),
                      onPressed: () => _showBlockDialog(context, ref, user),
                      tooltip: '차단',
                    ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
    );
  }

  void _showRoleDialog(BuildContext context, WidgetRef ref, AppUserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.name} 권한 변경'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: UserRole.values.map((role) {
            return RadioListTile<UserRole>(
              title: Text(role.name.toUpperCase()),
              value: role,
              groupValue: user.role,
              onChanged: (newRole) {
                if (newRole != null) {
                  ref.read(adminActionsProvider).updateUserRole(user, newRole);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
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

class _TenantSettingsTab extends ConsumerWidget {
  const _TenantSettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantsAsync = ref.watch(adminAllTenantsProvider);

    return tenantsAsync.when(
      data: (tenants) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tenant.displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Chip(label: Text(tenant.id, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('최대 동시 접속자 수'),
                    subtitle: Text('${tenant.maxConcurrentUsers}명'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showMaxUsersDialog(context, ref, tenant),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('접속 게이트 활성화'),
                    subtitle: const Text('인원 초과 시 게이트 화면을 표시합니다.'),
                    value: tenant.gateEnabled,
                    onChanged: (val) {
                      ref.read(adminActionsProvider).updateTenantSettings(
                        tenantId: tenant.id,
                        maxConcurrentUsers: tenant.maxConcurrentUsers,
                        gateEnabled: val,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류: $e')),
    );
  }

  void _showMaxUsersDialog(BuildContext context, WidgetRef ref, Tenant tenant) {
    final controller = TextEditingController(text: tenant.maxConcurrentUsers.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${tenant.displayName} 상한 설정'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '최대 접속자 수'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null) {
                ref.read(adminActionsProvider).updateTenantSettings(
                  tenantId: tenant.id,
                  maxConcurrentUsers: val,
                  gateEnabled: tenant.gateEnabled,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
