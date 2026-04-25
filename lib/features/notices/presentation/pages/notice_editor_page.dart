import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notice_actions_provider.dart';

class NoticeEditorPage extends ConsumerStatefulWidget {
  const NoticeEditorPage({super.key});

  @override
  ConsumerState<NoticeEditorPage> createState() => _NoticeEditorPageState();
}

class _NoticeEditorPageState extends ConsumerState<NoticeEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPinned = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(noticeActionsProvider).createNotice(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        isPinned: _isPinned,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('공지사항 등록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('제목', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A535C))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: '공지사항 제목을 입력하세요',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? '제목을 입력해 주세요' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text('내용', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A535C))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: '공지사항 내용을 입력하세요',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? '내용을 입력해 주세요' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('상단 고정', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A535C))),
                            Text('리스트 최상단에 항상 노출됩니다', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Switch(
                          value: _isPinned,
                          onChanged: (val) => setState(() => _isPinned = val),
                          activeColor: const Color(0xFF1A535C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A535C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('작성 완료', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
