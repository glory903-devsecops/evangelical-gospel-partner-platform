import 'package:flutter/material.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF7),
      appBar: AppBar(
        title: const Text('전도 메뉴얼', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: const Color(0xFFF7FFF7),
        foregroundColor: const Color(0xFF1A535C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildManualCard(
              '1. 첫인사와 태도',
              '밝은 미소와 단정한 복장으로 다가갑니다. 상대방의 상황을 배려하며 정중하게 인사를 건넵니다.',
              Icons.face_retouching_natural_rounded,
              const Color(0xFF4ECDC4),
            ),
            const SizedBox(height: 16),
            _buildManualCard(
              '2. 핵심 메시지 전달',
              '복음의 핵심 내용을 명확하고 간결하게 전달합니다. 상대방의 질문에 경청하며 답변합니다.',
              Icons.message_rounded,
              const Color(0xFF1A535C),
            ),
            const SizedBox(height: 16),
            _buildManualCard(
              '3. 사후 관리 및 기도',
              '관심을 보인 분들의 연락처를 정중히 묻고, 지속적인 기도와 관심을 약속합니다.',
              Icons.volunteer_activism_rounded,
              const Color(0xFFFF6B6B),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A535C).withOpacity(0.1)),
              ),
              child: const Column(
                children: [
                  Text(
                    '“그러므로 너희는 가서 모든 민족을 제자로 삼아 아버지와 아들과 성령의 이름으로 세례를 베풀고”',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15, color: Color(0xFF1A535C)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text('- 마태복음 28:19 -', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                const SizedBox(height: 8),
                Text(content, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
