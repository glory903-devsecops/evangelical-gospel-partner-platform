import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/tenant.dart';

void main() {
  group('Tenant Providers Test', () {
    test('currentTenantIdProvider defaults to anguk', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(currentTenantIdProvider), 'anguk');
    });

    test('currentTenantIdProvider updates value correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentTenantIdProvider.notifier).state = 'samseong';
      expect(container.read(currentTenantIdProvider), 'samseong');
    });
  });
}
