import 'package:flutter/material.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/announcements.dart';
import 'package:intl/intl.dart';

class NoticeDetailPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('공지사항 상세', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notice.isPinned)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A535C),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '중요 공지',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            Text(
              notice.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('관리자', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy년 MM월 dd일 HH:mm').format(notice.createdAt),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              notice.content,
              style: const TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
