import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/tenant_providers.dart';

class TenantSelectPage extends ConsumerWidget {
  const TenantSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () {
                // 테넌트 ID 업데이트
                ref.read(currentTenantIdProvider.notifier).state = tenant['id'];
                context.go('/home');
              },
            ),
          );
        },
      ),
    );
  }
}
