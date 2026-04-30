import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evangelical_gospel_partner/features/churches/data/models/church_model.dart';
import 'package:evangelical_gospel_partner/features/churches/data/repositories/church_repository.dart';
import 'package:evangelical_gospel_partner/features/tenant/presentation/providers/tenant_providers.dart';

final churchRepositoryProvider = Provider((ref) => ChurchRepository());

final churchesStreamProvider = StreamProvider<List<ChurchModel>>((ref) {
  final tenantId = ref.watch(currentTenantIdProvider);
  return ref.watch(churchRepositoryProvider).getChurchesByTenant(tenantId ?? '');
});

final churchSearchQueryProvider = StateProvider<String>((ref) => '');
final churchSortColumnProvider = StateProvider<String>((ref) => 'distance'); // distance, name, memberCount
final churchSortAscendingProvider = StateProvider<bool>((ref) => true);

final filteredChurchesProvider = Provider<List<ChurchModel>>((ref) {
  final churchesAsync = ref.watch(churchesStreamProvider);
  final query = ref.watch(churchSearchQueryProvider).toLowerCase();
  final sortColumn = ref.watch(churchSortColumnProvider);
  final ascending = ref.watch(churchSortAscendingProvider);

  return churchesAsync.when(
    data: (churches) {
      final filtered = churches.where((ChurchModel c) {
        return c.name.toLowerCase().contains(query) ||
               c.denomination.toLowerCase().contains(query) ||
               c.pastorName.toLowerCase().contains(query);
      }).toList();

      filtered.sort((ChurchModel a, ChurchModel b) {
        int result = 0;
        switch (sortColumn) {
          case 'name':
            result = a.name.compareTo(b.name);
            break;
          case 'memberCount':
            result = a.memberCount.compareTo(b.memberCount);
            break;
          case 'youthCount':
            result = a.youthCount.compareTo(b.youthCount);
            break;
          case 'distance':
          default:
            result = a.distance.compareTo(b.distance);
            break;
        }
        return ascending ? result : -result;
      });

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
