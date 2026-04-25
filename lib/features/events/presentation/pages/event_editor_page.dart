import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/event_actions_provider.dart';

class EventEditorPage extends ConsumerStatefulWidget {
  const EventEditorPage({super.key});

  @override
  ConsumerState<EventEditorPage> createState() => _EventEditorPageState();
}

class _EventEditorPageState extends ConsumerState<EventEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxApplicantsController = TextEditingController(text: '10');
  
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _maxApplicantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A535C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked; else _endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A535C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked; else _endTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final startAt = DateTime(_startDate.year, _startDate.month, _startDate.day, _startTime.hour, _startTime.minute);
    final endAt = DateTime(_endDate.year, _endDate.month, _endDate.day, _endTime.hour, _endTime.minute);

    if (endAt.isBefore(startAt)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('종료 시간이 시작 시간보다 빠를 수 없습니다.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(eventActionsProvider).createEvent(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        startAt: startAt,
        endAt: endAt,
        maxApplicants: int.parse(_maxApplicantsController.text),
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
        title: const Text('행사 및 모임 등록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                    _buildLabel('행사 정보'),
                    const SizedBox(height: 12),
                    _buildTextField(_titleController, '행사 제목을 입력하세요', validator: (v) => (v == null || v.isEmpty) ? '제목을 입력해 주세요' : null),
                    const SizedBox(height: 12),
                    _buildTextField(_locationController, '장소를 입력하세요 (ex. 본당, 203호)', icon: Icons.location_on_outlined),
                    const SizedBox(height: 24),
                    
                    _buildLabel('행사 일시'),
                    const SizedBox(height: 12),
                    _buildDateTimePicker('시작', _startDate, _startTime, true),
                    const SizedBox(height: 8),
                    _buildDateTimePicker('종료', _endDate, _endTime, false),
                    const SizedBox(height: 24),

                    _buildLabel('상세 내용 및 모집'),
                    const SizedBox(height: 12),
                    _buildTextField(_maxApplicantsController, '모집 정원 (숫자)', icon: Icons.group_outlined, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildTextField(_descController, '행사 상세 설명을 입력하세요', maxLines: 5),
                    
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
                        child: const Text('등록 하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A535C)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {IconData? icon, int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimePicker(String label, DateTime date, TimeOfDay time, bool isStart) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, isStart),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
              child: Text(DateFormat('yyyy.MM.dd').format(date)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context, isStart),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
              child: Text(time.format(context)),
            ),
          ),
        ),
      ],
    );
  }
}
