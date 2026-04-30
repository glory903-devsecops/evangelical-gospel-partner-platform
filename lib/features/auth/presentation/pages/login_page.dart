import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_actions_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authActionsProvider).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // 성공 시 자동으로 홈으로 이동 (router의 authStateChangesProvider 리스너에 의해)
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authActionsProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구글 로그인 실패: $e')),
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
                  // Logo Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, size: 48, color: Color(0xFF1A535C)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '전도 파트너',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const Text(
                    'Evangelical Gospel Partner',
                    style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 40),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          label: '이메일',
                          icon: Icons.email_outlined,
                          hint: 'user@example.com',
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          label: '비밀번호',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A535C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: _isLoading 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('로그인', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Google Login
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleGoogleLogin,
                            icon: Image.network(
                              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                              height: 24,
                            ),
                            label: const Text('Google로 계속하기', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _showFindEmailDialog(context, ref),
                              child: Text('아이디 찾기', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            ),
                            Container(width: 1, height: 12, color: Colors.grey.shade300),
                            TextButton(
                              onPressed: () => _showResetPasswordDialog(context, ref),
                              child: Text('비밀번호 재설정', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('계정이 없으신가요?', style: TextStyle(color: Colors.white, fontSize: 15)),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: const Text(
                          '회원가입 하기',
                          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A535C))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF1A535C).withOpacity(0.5)),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }

  void _showFindEmailDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final birthDateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이디(이메일) 찾기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⚠️ 구글 계정으로 로그인한 경우 가입 정보가 없다고 표시됩니다.',
              style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: '이름'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: birthDateController,
              decoration: const InputDecoration(hintText: '생년월일 6자리 (예: 900101)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              final email = await ref.read(authActionsProvider).findEmail(
                name: nameController.text.trim(),
                birthDate: birthDateController.text.trim(),
              );
              if (context.mounted) {
                Navigator.pop(context);
                if (email != null) {
                  _showFindResultDialog(context, email);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일치하는 계정 정보가 없습니다.')),
                  );
                }
              }
            },
            child: const Text('찾기'),
          ),
        ],
      ),
    );
  }

  void _showFindResultDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이디 찾기 결과'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('찾으시는 아이디는 다음과 같습니다.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                email,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showResetPasswordDialog(context, ref);
            },
            child: const Text('비밀번호 찾기(재설정)'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final birthDateController = TextEditingController();
    final newPasswordController = TextEditingController();
    
    bool isVerified = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isVerified ? '새 비밀번호 설정' : '계정 정보 확인'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isVerified) ...[
                  const Text('아이디, 이름, 생년월일을 모두 입력해 주세요.', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextField(controller: emailController, decoration: const InputDecoration(hintText: '아이디 (이메일)')),
                  const SizedBox(height: 8),
                  TextField(controller: nameController, decoration: const InputDecoration(hintText: '이름')),
                  const SizedBox(height: 8),
                  TextField(
                    controller: birthDateController, 
                    decoration: const InputDecoration(hintText: '생년월일 6자리'),
                    keyboardType: TextInputType.number,
                  ),
                ] else ...[
                  const Text('본인 확인이 완료되었습니다.\n새로운 비밀번호를 입력해 주세요.', style: TextStyle(fontSize: 13, color: Color(0xFF1A535C))),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController, 
                    decoration: const InputDecoration(hintText: '새 비밀번호 (6자 이상)'),
                    obscureText: true,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
            if (!isVerified)
              TextButton(
                onPressed: () async {
                  // 1단계: 정보 일치 확인 (아이디 찾기 로직 재사용)
                  final foundEmail = await ref.read(authActionsProvider).findEmail(
                    name: nameController.text.trim(),
                    birthDate: birthDateController.text.trim(),
                  );
                  
                  if (foundEmail == emailController.text.trim()) {
                    setState(() => isVerified = true);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('입력하신 정보가 일치하지 않습니다.')));
                    }
                  }
                },
                child: const Text('다음'),
              )
            else
              TextButton(
                onPressed: () async {
                  // 2단계: 백엔드 함수 호출하여 비밀번호 변경
                  try {
                    await ref.read(authActionsProvider).resetPasswordDirectly(
                      email: emailController.text.trim(),
                      name: nameController.text.trim(),
                      birthDate: birthDateController.text.trim(),
                      newPassword: newPasswordController.text.trim(),
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('변경 실패: $e')));
                    }
                  }
                },
                child: const Text('변경 완료'),
              ),
          ],
        ),
      ),
    );
  }
}
