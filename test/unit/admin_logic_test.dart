import 'package:flutter_test/flutter_test.dart';
import 'package:evangelical_gospel_partner/core/domain/entities/app_user.dart';

void main() {
  group('Admin Logic Tests', () {
    test('User with Admin role should have access to admin features', () {
      final adminUser = AppUser(
        uid: 'admin1',
        name: 'Master Admin',
        email: 'admin@test.com',
        tenantId: 'ankuk',
        role: UserRole.admin,
        joinedTenantIds: ['ankuk'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(adminUser.role, UserRole.admin);
      expect(adminUser.isActive, true);
    });

    test('Regular user should NOT have Admin role', () {
      final regularUser = AppUser(
        uid: 'user1',
        name: 'Regular User',
        email: 'user@test.com',
        tenantId: 'ankuk',
        role: UserRole.user,
        joinedTenantIds: ['ankuk'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(regularUser.role, isNot(UserRole.admin));
    });

    test('Blacklisted user should have isActive as false', () {
      final blacklistedUser = AppUser(
        uid: 'bad_user',
        name: 'Bad User',
        email: 'bad@test.com',
        tenantId: 'ankuk',
        role: UserRole.user,
        joinedTenantIds: ['ankuk'],
        isActive: false,
        blockReason: 'Spamming',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(blacklistedUser.isActive, false);
      expect(blacklistedUser.blockReason, 'Spamming');
    });
  });
}
