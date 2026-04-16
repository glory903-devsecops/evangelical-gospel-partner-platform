import 'package:flutter/material.dart';

class GatePage extends StatelessWidget {
  const GatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A535C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person_rounded, size: 80, color: Colors.white70),
              const SizedBox(height: 32),
              const Text(
                '현재 동시 접속 허용 인원은 100명입니다.',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                '현재 접속자가 많아 잠시 입장이 제한됩니다.\n잠시 후 다시 시도해 주세요.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 접속자 수 재조회 로직 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A535C),
                  ),
                  child: const Text('현재 접속자 재확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
