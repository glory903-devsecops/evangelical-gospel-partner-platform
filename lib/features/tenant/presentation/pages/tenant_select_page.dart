import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantSelectPage extends StatelessWidget {
  const TenantSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tenants = [
      {'id': 'anguk', 'name': '안국역 전도 파트너'},
      {'id': 'samseong', 'name': '삼성역 전도 파트너'},
      {'id': 'pangyo', 'name': '판교역 전도 파트너'},
      {'id': 'dasan', 'name': '다산역 전도 파트너'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('지역(테넌트) 선택')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(tenant['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/home'), // 현재은 바로 홈으로 이동
            ),
          );
        },
      ),
    );
  }
}
