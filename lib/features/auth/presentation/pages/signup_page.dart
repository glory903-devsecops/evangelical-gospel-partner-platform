import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_actions_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthDateController = TextEditingController(); // 생년월일 추가
  
  String _selectedTenant = 'anguk';
  bool _isLoading = false;

  final List<Map<String, String>> tenants = [
    {'id': 'anguk', 'name': '안국역 전도 파트너'},
    {'id': 'samseong', 'name': '삼성역 전도 파트너'},
    {'id': 'pangyo', 'name': '판교역 전도 파트너'},
    {'id': 'dasan', 'name': '다산역 전도 파트너'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authActionsProvider).signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        tenantId: _selectedTenant,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다!')),
        );
        context.go('/home'); // 가입 성공 시 바로 홈으로
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('가입 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A535C), Color(0xFF4ECDC4)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.0),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '전도 파트너가 되어 함께 소통해요',
                    style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),

                  // Signup Form Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Social Login First
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : () async {
                                setState(() => _isLoading = true);
                                try {
                                  await ref.read(authActionsProvider).signInWithGoogle(tenantId: _selectedTenant);
                                } catch (e) {
                                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('구글 가입 실패: $e')));
                                } finally {
                                  if (mounted) setState(() => _isLoading = false);
                                }
                              },
                              icon: Image.network('https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg', height: 24),
                              label: const Text('Google로 시작하기', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('또는 이메일로 가입', style: TextStyle(color: Colors.grey, fontSize: 13))),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),

                          _buildFormField(
                            controller: _nameController,
                            label: '이름',
                            icon: Icons.person_outline,
                            validator: (v) => (v == null || v.isEmpty) ? '이름을 입력해 주세요' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            controller: _emailController,
                            label: '이메일',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || !v.contains('@')) ? '올바른 이메일을 입력해 주세요' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            controller: _birthDateController,
                            label: '생년월일 (6자리)',
                            icon: Icons.calendar_today_outlined,
                            hint: '예: 900101',
                            keyboardType: TextInputType.number,
                            validator: (v) => (v == null || v.length != 6) ? '6자리 숫자로 입력해 주세요' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            controller: _passwordController,
                            label: '비밀번호',
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: (v) => (v == null || v.length < 6) ? '6자 이상 입력해 주세요' : null,
                          ),
                          const SizedBox(height: 24),
                          
                          const Text('활동 지역 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A535C))),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedTenant,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF1A535C)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            items: tenants.map((t) {
                              return DropdownMenuItem(value: t['id'], child: Text(t['name']!));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedTenant = val);
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A535C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('가입 완료', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      '이미 계정이 있으신가요? 로그인',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A535C))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1A535C).withOpacity(0.5)),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }
}
