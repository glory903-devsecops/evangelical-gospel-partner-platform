import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:evangelical_gospel_partner/features/churches/presentation/providers/church_providers.dart';
import 'package:evangelical_gospel_partner/core/services/map_service.dart';

class ChurchInfoPage extends ConsumerWidget {
  const ChurchInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churches = ref.watch(filteredChurchesProvider);
    final query = ref.watch(churchSearchQueryProvider);
    final sortColumn = ref.watch(churchSortColumnProvider);
    final ascending = ref.watch(churchSortAscendingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('교회 디렉토리', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A535C),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => context.push('/church-edit'),
            tooltip: '교회 등록',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => ref.read(churchSearchQueryProvider.notifier).state = val,
                  decoration: InputDecoration(
                    hintText: '교회명, 교단, 담임목사 검색...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSortChip(ref, '거리순', 'distance', sortColumn, ascending),
                      const SizedBox(width: 8),
                      _buildSortChip(ref, '이름순', 'name', sortColumn, ascending),
                      const SizedBox(width: 8),
                      _buildSortChip(ref, '성도수순', 'memberCount', sortColumn, ascending),
                      const SizedBox(width: 8),
                      _buildSortChip(ref, '청년수순', 'youthCount', sortColumn, ascending),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // List View
          Expanded(
            child: churches.isEmpty
              ? const Center(child: Text('검색 결과가 없습니다.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: churches.length,
                  itemBuilder: (context, index) {
                    final church = churches[index];
                    return _buildChurchCard(context, church);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(WidgetRef ref, String label, String column, String currentColumn, bool ascending) {
    final isSelected = column == currentColumn;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isSelected) ...[
            const SizedBox(width: 4),
            Icon(ascending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 14),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (val) {
        if (isSelected) {
          ref.read(churchSortAscendingProvider.notifier).state = !ascending;
        } else {
          ref.read(churchSortColumnProvider.notifier).state = column;
          ref.read(churchSortAscendingProvider.notifier).state = true;
        }
      },
      selectedColor: const Color(0xFF1A535C).withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1A535C) : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildChurchCard(BuildContext context, dynamic church) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        church.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A535C)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        church.denomination,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4ECDC4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('담임목사: ${church.pastorName}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildIconLabel(Icons.people_outline, '성도 ${church.memberCount}'),
                    const SizedBox(width: 16),
                    _buildIconLabel(Icons.school_outlined, '청년 ${church.youthCount}'),
                    const SizedBox(width: 16),
                    _buildIconLabel(Icons.directions_walk_rounded, '${church.distance}m'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '올해의 말씀: ${church.yearlyWord}',
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF1A535C)),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showNavigationPopup(context, church),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A535C).withOpacity(0.05),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.near_me_rounded, size: 18, color: Color(0xFF1A535C)),
                  SizedBox(width: 8),
                  Text('길찾기', style: TextStyle(color: Color(0xFF1A535C), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }

  void _showNavigationPopup(BuildContext context, dynamic church) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('내비게이션 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildMapOption('네이버 지도', Icons.map_outlined, () {
              MapService.openNaverMap(church.address, church.latitude, church.longitude);
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            _buildMapOption('카카오맵', Icons.map_outlined, () {
              MapService.openKakaoMap(church.address, church.latitude, church.longitude);
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
            _buildMapOption('TMap', Icons.map_outlined, () {
              MapService.openTMap(church.address, church.latitude, church.longitude);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOption(String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.navigation_rounded, color: Color(0xFF1A535C)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
    );
  }
}
