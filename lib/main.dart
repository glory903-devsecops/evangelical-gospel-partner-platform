import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/routes/router.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'core/services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (생성된 설정 파일 사용)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: EvangelicalGospelApp(),
    ),
  );
}

class EvangelicalGospelApp extends ConsumerWidget {
  const EvangelicalGospelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 테넌트 동기화 및 세션 체크 로직 활성화
    ref.watch(authInitializationProvider);
    ref.watch(sessionCheckProvider);
    
    final router = ref.watch(routerProvider);
    final authInit = ref.watch(currentUserProvider);

    return authInit.when(
      data: (user) => MaterialApp.router(
        title: '전도 파트너 플랫폼',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A535C),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.notoSansKrTextTheme(),
        ),
        routerConfig: router,
      ),
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text('앱 초기화 오류: $err', textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(authActionsProvider).logout(),
                  child: const Text('다시 로그인 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
