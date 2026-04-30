import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/church_providers.dart';
import '../../data/models/church_model.dart';
import '../../../tenant/presentation/providers/tenant_providers.dart';

class ChurchEditorPage extends ConsumerStatefulWidget {
  const ChurchEditorPage({super.key});

  @override
  ConsumerState<ChurchEditorPage> createState() => _ChurchEditorPageState();
}

class _ChurchEditorPageState extends ConsumerState<ChurchEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _denominationController = TextEditingController();
  final _pastorController = TextEditingController();
  final _memberCountController = TextEditingController();
  final _youthCountController = TextEditingController();
  final _distanceController = TextEditingController();
  final _addressController = TextEditingController();
  final _yearlyWordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _denominationController.dispose();
    _pastorController.dispose();
    _memberCountController.dispose();
    _youthCountController.dispose();
    _distanceController.dispose();
    _addressController.dispose();
    _yearlyWordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final tenantId = ref.read(currentTenantIdProvider);
      final church = ChurchModel(
        id: '', // Firestore will generate
        tenantId: tenantId ?? '',
        name: _nameController.text,
        denomination: _denominationController.text,
        pastorName: _pastorController.text,
        memberCount: int.tryParse(_memberCountController.text) ?? 0,
        youthCount: int.tryParse(_youthCountController.text) ?? 0,
        distance: int.tryParse(_distanceController.text) ?? 0,
        address: _addressController.text,
        yearlyWord: _yearlyWordController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(churchRepositoryProvider).addChurch(church);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 실패: $e')),
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
        title: const Text('교회 등록', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSectionTitle('기본 정보'),
                  const SizedBox(height: 16),
                  _buildTextField(_nameController, '교회 이름', Icons.church_rounded, '이름을 입력하세요'),
                  const SizedBox(height: 12),
                  _buildTextField(_denominationController, '교단', Icons.account_balance_rounded, '예: 대한예수교장로회'),
                  const SizedBox(height: 12),
                  _buildTextField(_pastorController, '담임 목사', Icons.person_rounded, '성함을 입력하세요'),
                  
                  const SizedBox(height: 32),
                  _buildSectionTitle('상세 정보'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_memberCountController, '성도 수', Icons.people_rounded, '0', isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField(_youthCountController, '청년 수', Icons.school_rounded, '0', isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(_distanceController, '전철역에서의 거리(m)', Icons.directions_walk_rounded, '예: 300', isNumber: true),
                  const SizedBox(height: 12),
                  _buildTextField(_addressController, '주소', Icons.location_on_rounded, '정확한 주소를 입력하세요'),
                  
                  const SizedBox(height: 32),
                  _buildSectionTitle('메시지'),
                  const SizedBox(height: 16),
                  _buildTextField(_yearlyWordController, '올해 하나님이 주신 말씀', Icons.auto_awesome_rounded, '말씀 구절을 입력하세요', maxLines: 3),
                  
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A535C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('등록 완료', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    String hint, 
    {bool isNumber = false, int maxLines = 1}
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (val) => (val == null || val.isEmpty) ? '$label을(를) 입력해주세요' : null,
    );
  }
}
