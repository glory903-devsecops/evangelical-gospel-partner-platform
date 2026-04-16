import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 추후 Firebase 초기화 로직 추가 예정
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
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
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '전도 파트너 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A535C), // 신뢰감을 주는 딥 그린/블루 톤
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.notoSansKrTextTheme(),
      ),
      routerConfig: router,
    );
  }
}
