import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/events/presentation/providers/event_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/auth/presentation/providers/auth_providers.dart';


class EventListPage extends ConsumerWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(activeEventsProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final canEdit = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.operator;


    return Scaffold(
      appBar: AppBar(
        title: const Text('모임 및 행사', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1A535C),
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('진행 중인 행사가 없습니다.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _EventCard(event: event);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => context.push('/event-edit'),
              backgroundColor: const Color(0xFF1A535C),
              child: const Icon(Icons.add_task_rounded, color: Colors.white),
            )
          : null,
    );
  }
}


class _EventCard extends StatelessWidget {
  final Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/event-detail', extra: event),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A535C).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.event_available, size: 32, color: const Color(0xFF1A535C).withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: event.status),
                      Text(
                        '${event.currentApplicants}/${event.maxApplicants}명',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${DateFormat('MM.dd HH:mm').format(event.startAt)} ~ ${DateFormat('HH:mm').format(event.endAt)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: event.status == EventStatus.open ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A535C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('참가 신청하기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final EventStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case EventStatus.open:
        color = Colors.green;
        text = '접수중';
        break;
      case EventStatus.closed:
        color = Colors.orange;
        text = '마감';
        break;
      case EventStatus.ended:
        color = Colors.grey;
        text = '종료';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
