import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_providers.dart';
import 'package:evangelical_gospel_partner/features/notices/presentation/providers/notice_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:intl/intl.dart';

class NoticeListPage extends ConsumerWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(allNoticesProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final canEdit = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.operator;


    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1A535C),
      ),
      body: noticesAsync.when(
        data: (notices) {
          if (notices.isEmpty) {
            return const Center(child: Text('등록된 공지사항이 없습니다.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return _NoticeCard(notice: notice);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => context.push('/notice-edit'),
              backgroundColor: const Color(0xFF1A535C),
              child: const Icon(Icons.add_comment_rounded, color: Colors.white),
            )
          : null,
    );
  }
}


class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/notice-detail', extra: notice),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (notice.isPinned)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A535C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '중요',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      notice.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notice.content,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy.MM.dd').format(notice.createdAt),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
