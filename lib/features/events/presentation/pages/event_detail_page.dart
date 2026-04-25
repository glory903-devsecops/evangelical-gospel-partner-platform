import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:evangelical_gospel_partner/features/events/domain/entities/event_application.dart';
import 'package:intl/intl.dart';
import '../providers/event_application_providers.dart';

class EventDetailPage extends ConsumerWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationStatusAsync = ref.watch(userApplicationStatusProvider(event.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('행사 상세 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A535C).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(Icons.celebration_rounded, size: 64, color: const Color(0xFF1A535C).withOpacity(0.3)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StatusChip(status: event.status),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(Icons.calendar_today, '일시', 
                      '${DateFormat('yyyy.MM.dd(E)').format(event.startAt)}  ${DateFormat('HH:mm').format(event.startAt)} ~ ${DateFormat('HH:mm').format(event.endAt)}'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.location_on_outlined, '장소', event.location),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.group_outlined, '정원', '${event.currentApplicants} / ${event.maxApplicants}명 (선착순)'),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                  const Text('행사 설명', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF444444)),
                  ),
                  const SizedBox(height: 100), // 여백
                ],
              ),
            ),
          ),
          applicationStatusAsync.when(
            data: (application) => _buildStickyButton(context, ref, application),
            loading: () => const LinearProgressIndicator(),
            error: (e, __) => Center(child: Text('오류: $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1A535C)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildStickyButton(BuildContext context, WidgetRef ref, EventApplication? application) {
    final isApplied = application?.status == ApplicationStatus.applied;
    final isFull = event.currentApplicants >= event.maxApplicants;
    final isOpen = event.status == EventStatus.open;

    String buttonText = '지금 참가 신청하기';
    Color buttonColor = const Color(0xFF1A535C);
    VoidCallback? onPressed = () => _handleJoin(context, ref);

    if (isApplied) {
      buttonText = '신청 취소하기';
      buttonColor = Colors.red.shade400;
      onPressed = () => _handleCancel(context, ref);
    } else if (!isOpen) {
      buttonText = '접수 대상 행사가 아닙니다';
      onPressed = null;
    } else if (isFull) {
      buttonText = '정원이 마감되어 신청할 수 없습니다';
      onPressed = null;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _handleJoin(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(applicationActionsProvider).join(event.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('참가 신청이 완료되었습니다!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('신청 실패: $e')));
      }
    }
  }

  Future<void> _handleCancel(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(applicationActionsProvider).cancel(event.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('신청이 취소되었습니다.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('취소 실패: $e')));
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final EventStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case EventStatus.open:
        color = Colors.green;
        text = '접수 중';
        break;
      case EventStatus.closed:
        color = Colors.orange;
        text = '접수 마감';
        break;
      case EventStatus.ended:
        color = Colors.grey;
        text = '행사 종료';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
